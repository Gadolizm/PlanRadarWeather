//
//  OWResponse.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation

// OpenWeather models (mirror JSON)
struct OWMain: Decodable { let temp: Double; let humidity: Double }
struct OWWind: Decodable { let speed: Double }
struct OWWeather: Decodable { let description: String; let icon: String }

/// Root for /data/2.5/weather
struct OWResponse: Decodable {
    let weather: [OWWeather]
    let main: OWMain
    let wind: OWWind
}
