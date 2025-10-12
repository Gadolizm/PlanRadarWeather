//
//  AddOrGetCityUseCase.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation

protocol AddOrGetCityUseCase {
    func run(name: String) throws -> CityEntity
}

struct AddOrGetCity: AddOrGetCityUseCase {
    private let repo: WeatherRepository
    init(repo: WeatherRepository) { self.repo = repo }

    func run(name: String) throws -> CityEntity {
        try repo.ensureCity(named: name)
    }
}