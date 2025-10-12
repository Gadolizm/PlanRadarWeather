//
//  WeatherRemote.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//


import Foundation

// Internal = visible to tests via @testable
protocol WeatherRemote {
    func fetchRaw(city: String) async throws -> Data
}

// Your existing façade now conforms
extension WeatherNetworking: WeatherRemote {}