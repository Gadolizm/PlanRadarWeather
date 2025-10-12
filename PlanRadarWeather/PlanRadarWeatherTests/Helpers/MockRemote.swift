//
//  MockRemote.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//


import Foundation
@testable import PlanRadarWeather

// Your facade already conforms to WeatherRemote; this is a test double.
final class MockRemote: WeatherRemote {
    enum Behavior { case success(Data), failure(Error) }
    var behavior: Behavior
    private(set) var lastCity: String?

    init(_ behavior: Behavior) { self.behavior = behavior }

    func fetchRaw(city: String) async throws -> Data {
        lastCity = city
        switch behavior {
        case .success(let d): return d
        case .failure(let e): throw e
        }
    }
}