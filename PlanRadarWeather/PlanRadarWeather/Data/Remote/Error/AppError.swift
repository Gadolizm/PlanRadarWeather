//
//  AppError.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation

// MARK: - Error Model (user-presentable, testable)

/// Unified, user-presentable error surface for networking.
enum AppError: LocalizedError {
    // Transport layer
    case network(URLError)                     // timeouts, DNS, offline, etc.
    case cancelled                             // task was cancelled
    case invalidResponse                       // not an HTTP response
    case emptyBody                             // 2xx but no body
    case invalidContentType(String)            // e.g., text/html instead of JSON

    // HTTP layer (semantic)
    case unauthorized                          // 401: wrong/missing API key
    case notFound                               // 404: city not found
    case rateLimited(retryAfter: TimeInterval?)// 429: too many requests
    case httpStatus(code: Int, reason: String, bodyPreview: String?) // other non-2xx

    // Generic
    case unknown(String)
}

extension AppError {
    var errorDescription: String? {
        switch self {
        case .network(let e):
            return "Network error: \(e.localizedDescription)"
        case .cancelled:
            return "Request was cancelled."
        case .invalidResponse:
            return "Invalid server response."
        case .emptyBody:
            return "Server returned an empty response."
        case .invalidContentType(let ct):
            return "Unexpected content type: \(ct)"
        case .unauthorized:
            return "Unauthorized: Check your API key."
        case .notFound:
            return "City not found. Please verify the name."
        case .rateLimited(let after):
            if let after { return "Too many requests. Try again in \(Int(after))s." }
            return "Too many requests. Please try again shortly."
        case .httpStatus(let code, let reason, let preview):
            if let preview, !preview.isEmpty {
                return "Server error (\(code) \(reason)): \(preview)"
            }
            return "Server error (\(code) \(reason))."
        case .unknown(let msg):
            return msg
        }
    }
}