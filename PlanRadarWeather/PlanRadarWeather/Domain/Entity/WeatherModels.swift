//
//  WeatherModels.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation

// MARK: - City (Domain)

/// Domain entity representing a City (framework-agnostic).
public struct CityEntity: Equatable, Hashable, Sendable {
    public let id: UUID
    public let name: String            // normalized (trimmed, single-spaced, capitalized)
    public let createdAt: Date

    /// Normalizing initializer (throws if name is empty after trimming).
    public init(id: UUID = UUID(), name rawName: String, createdAt: Date = .init()) {
        let normalized = CityEntity.normalizeName(rawName)
        precondition(!normalized.isEmpty, "City name must not be empty")
        self.id = id
        self.name = normalized
        self.createdAt = createdAt
    }
}

public extension CityEntity {
    /// Lowercased key useful for case-insensitive matching.
    var lookupKey: String { name.lowercased() }

    /// Normalizes a user-entered city name (trim + collapse spaces + titlecase ASCII).
    static func normalizeName(_ s: String) -> String {
        let trimmed = s.trimmingCharacters(in: .whitespacesAndNewlines)
        // collapse consecutive spaces
        let collapsed = trimmed.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
        // lightweight titlecasing (avoid Locale impact)
        return collapsed.capitalized
    }
}

// MARK: - Identifiable conformance for CityEntity used with .sheet(item:)
extension CityEntity: Identifiable {}

// MARK: - Weather Snapshot (Domain)

/// Domain entity for a single weather reading (history item).
public struct WeatherSnapshot: Equatable, Hashable, Comparable, Sendable {
    public let id: UUID
    public let requestedAt: Date       // when we fetched this reading
    public let summary: String         // short condition text (e.g., "clear sky")
    public let tempC: Double           // Celsius
    public let humidity: Double        // 0...100
    public let windSpeed: Double       // m/s
    public let iconID: String          // e.g., "01d"

    public init(
        id: UUID = UUID(),
        requestedAt: Date = .init(),
        summary: String,
        tempC: Double,
        humidity: Double,
        windSpeed: Double,
        iconID: String
    ) {
        self.id = id
        self.requestedAt = requestedAt
        self.summary = summary
        self.tempC = tempC
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.iconID = iconID
    }

    /// Comparable by time (newest first when using `sorted(by: >)`).
    public static func < (lhs: WeatherSnapshot, rhs: WeatherSnapshot) -> Bool {
        lhs.requestedAt < rhs.requestedAt
    }
}

// MARK: - Convenience (formatting without UI frameworks)

public extension WeatherSnapshot {
    var tempCString: String { String(format: "%.1f ℃", tempC) }
    var humidityString: String { "\(Int(humidity)) %" }
    var windString: String { String(format: "%.1f m/s", windSpeed) }
}

// MARK: - Collection helpers

public extension Array where Element == WeatherSnapshot {
    func newestFirst() -> [WeatherSnapshot] {
        sorted { $0.requestedAt > $1.requestedAt }
    }
    func oldestFirst() -> [WeatherSnapshot] {
        sorted { $0.requestedAt < $1.requestedAt }
    }
}

// MARK: - Lightweight fixtures (for previews/tests)

public extension CityEntity {
    static let preview = CityEntity(name: "Cairo")
}

public extension WeatherSnapshot {
    static let preview = WeatherSnapshot(
        summary: "clear sky",
        tempC: 27,
        humidity: 40,
        windSpeed: 3.6,
        iconID: "01d"
    )
}
