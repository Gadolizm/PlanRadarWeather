//
//  ListCitiesUseCase.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation

protocol ListCitiesUseCase {
    func run() throws -> [CityEntity]
}

struct ListCities: ListCitiesUseCase {
    private let repo: WeatherRepository
    init(repo: WeatherRepository) { self.repo = repo }

    func run() throws -> [CityEntity] { try repo.allCities() }
}