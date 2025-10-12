//
//  DeleteCitiesUseCase.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation

protocol DeleteCitiesUseCase {
    func run(_ cities: [CityEntity]) throws
}

struct DeleteCities: DeleteCitiesUseCase {
    private let repo: WeatherRepository
    init(repo: WeatherRepository) { self.repo = repo }

    func run(_ cities: [CityEntity]) throws {
        try repo.deleteCities(cities)
    }
}