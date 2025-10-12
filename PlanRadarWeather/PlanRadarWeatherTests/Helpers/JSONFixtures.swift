//
//  JSONFixtures.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//


import Foundation

enum JSONFixtures {
    // Minimal OpenWeather "current" response → 20.0°C, 50% humidity, 3.6 m/s
    static let owOK: Data = """
    {
      "weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],
      "main":{"temp":293.15,"humidity":50},
      "wind":{"speed":3.6}
    }
    """.data(using: .utf8)!
}