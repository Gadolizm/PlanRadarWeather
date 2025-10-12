//
//  HTTPErrorMapping.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//

import Foundation

/// Namespaced helpers for mapping HTTP responses to `AppError` and extracting metadata.
/// Usage from `WeatherNetworking`:
///   let appErr = HTTPErrorMapping.mapHTTPError(http: http, data: data)
enum HTTPErrorMapping {

    /// Map non-2xx HTTP to a precise `AppError`, extracting Retry-After and a short body preview.
    static func mapHTTPError(http: HTTPURLResponse, data: Data?) -> AppError {
        let code = http.statusCode
        let reason = HTTPURLResponse.localizedString(forStatusCode: code)
        let preview = makePreview(from: data)

        switch code {
        case 401: return .unauthorized
        case 404: return .notFound
        case 429:
            let retry = parseRetryAfter(http)
            return .rateLimited(retryAfter: retry)
        default:
            return .httpStatus(code: code, reason: reason, bodyPreview: preview)
        }
    }

    /// Produce a safe, short UTF-8 preview of the response body (for logs/UI).
    static func makePreview(from data: Data?, max: Int = 180) -> String? {
        guard let data, !data.isEmpty else { return nil }
        let snippet = data.prefix(max)
        return String(data: snippet, encoding: .utf8)
    }

    /// Parse `Retry-After` header (seconds or HTTP-date). Returns seconds if parsable.
    static func parseRetryAfter(_ http: HTTPURLResponse) -> TimeInterval? {
        guard let raw = http.value(forHTTPHeaderField: "Retry-After")?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !raw.isEmpty else { return nil }

        // Option 1: integer seconds
        if let s = TimeInterval(raw) { return s }

        // Option 2: HTTP-date (RFC 7231) → compute delta to now
        let fmts = [
            "EEE',' dd MMM yyyy HH':'mm':'ss zzz",
            "EEEE',' dd-MMM-yy HH':'mm':'ss zzz"
        ]
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        for f in fmts {
            df.dateFormat = f
            if let date = df.date(from: raw) {
                return max(0, date.timeIntervalSinceNow)
            }
        }
        return nil
    }
}
