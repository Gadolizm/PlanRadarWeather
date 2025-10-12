//
//  FetchLatestWeatherUseCase.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation

protocol FetchLatestWeatherUseCase {
    func run(city: CityEntity) async throws -> WeatherSnapshot
}

struct FetchLatestWeather: FetchLatestWeatherUseCase {
    private let repo: WeatherRepository
    init(repo: WeatherRepository) { self.repo = repo }

    func run(city: CityEntity) async throws -> WeatherSnapshot {
        try await repo.fetchAndStoreLatest(for: city)
    }
}