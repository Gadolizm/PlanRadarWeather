//
//  WeatherNetworking.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


// MARK: - Swift façade over Objective-C client

/// Swift façade over the Obj-C `WeatherAPIClient`.
/// - Ensures: HTTP OK, content-type sane, returns Data or throws `AppError`.
struct WeatherNetworking {
    
    /// Fetch raw OpenWeather payload for a city.
    /// - Parameter city: Human-friendly city string (non-empty).
    /// - Returns: Raw `Data` (JSON) upon success.
    func fetchRaw(city: String) async throws -> Data {
        let trimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw AppError.unknown("City name must not be empty.") }
        
        return try await withCheckedThrowingContinuation { cont in
            WeatherAPIClient.shared().fetchWeather(forCity: trimmed) { data, response, error in
                // Transport / cancellation
                if let nsErr = error as NSError? {
                    if nsErr.domain == NSURLErrorDomain,
                       nsErr.code == NSURLErrorCancelled {
                        cont.resume(throwing: AppError.cancelled); return
                    }
                    if let urlErr = error as? URLError {
                        cont.resume(throwing: AppError.network(urlErr)); return
                    }
                    cont.resume(throwing: AppError.unknown(nsErr.localizedDescription))
                    return
                }
                
                // Must be HTTP
                guard let http = response as? HTTPURLResponse else {
                    cont.resume(throwing: AppError.invalidResponse); return
                }
                
                // Status code handling
                guard (200...299).contains(http.statusCode) else {
                    cont.resume(throwing: HTTPErrorMapping.mapHTTPError(http: http, data: data))
                    return
                }
                
                // Body present
                guard let body = data, !body.isEmpty else {
                    cont.resume(throwing: AppError.emptyBody); return
                }
                
                // Basic content-type guard (OpenWeather returns JSON)
                if let ct = http.value(forHTTPHeaderField: "Content-Type")?.lowercased(),
                   !ct.contains("application/json") {
                    cont.resume(throwing: AppError.invalidContentType(ct))
                    return
                }
                
                cont.resume(returning: body)
            }
        }
    }
}

