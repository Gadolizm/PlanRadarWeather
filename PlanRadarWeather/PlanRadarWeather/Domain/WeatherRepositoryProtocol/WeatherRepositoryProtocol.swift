//
//  WeatherRepositoryProtocol.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation

/// Abstraction between UseCases and Data layer (CoreData/Network).
protocol WeatherRepository {
    /// Ensure city exists (case-insensitive). Returns the domain city.
    func ensureCity(named: String) throws -> CityEntity

    /// Fetches latest weather from remote, persists it, and returns the persisted snapshot.
    func fetchAndStoreLatest(for city: CityEntity) async throws -> WeatherSnapshot

    /// Returns history (most recent first).
    func history(for city: CityEntity) throws -> [WeatherSnapshot]

    /// All cities saved so far.
    func allCities() throws -> [CityEntity]

    /// Delete cities (and their history).
    func deleteCities(_ cities: [CityEntity]) throws
}
