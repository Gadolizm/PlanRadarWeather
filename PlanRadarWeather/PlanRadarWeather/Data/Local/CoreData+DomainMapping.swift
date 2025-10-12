//
//  CoreData+DomainMapping.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//

import Foundation

// MARK: - Core Data → Domain mapping

extension City {
    func toDomain() -> CityEntity {
        CityEntity(id: id ?? UUID(),
                   name: name ?? "-",
                   createdAt: createdAt ?? Date())
    }
}

extension WeatherInfo {
    func toDomain() -> WeatherSnapshot {
        WeatherSnapshot(id: id ?? UUID(),
                        requestedAt: requestedAt ?? Date(),
                        summary: summary ?? "-",
                        tempC: tempC,
                        humidity: humidity,
                        windSpeed: windSpeed,
                        iconID: iconID ?? "")
    }
}
