//
//  OWResponse+DomainMapping.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//

import Foundation

// MARK: - API (OWResponse) → Domain mapping

extension OWResponse {
    func toDomainSnapshot() -> WeatherSnapshot {
        WeatherSnapshot(
            summary: weather.first?.description ?? "-",
            tempC: main.temp - 273.15,
            humidity: main.humidity,
            windSpeed: wind.speed,
            iconID: weather.first?.icon ?? ""
        )
    }
}
