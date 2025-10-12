//
//  GetCityHistoryUseCase.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation

protocol GetCityHistoryUseCase {
    func run(city: CityEntity) throws -> [WeatherSnapshot]
}

struct GetCityHistory: GetCityHistoryUseCase {
    private let repo: WeatherRepository
    init(repo: WeatherRepository) { self.repo = repo }

    func run(city: CityEntity) throws -> [WeatherSnapshot] {
        try repo.history(for: city)
    }
}