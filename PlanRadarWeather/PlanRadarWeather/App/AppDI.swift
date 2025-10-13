//
//  AppDI.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import CoreData

@MainActor
enum AppDI {
    private static var ctx: NSManagedObjectContext { PersistenceController.shared.viewContext }

    static var repo: WeatherRepository {
        WeatherRepositoryImpl(networking: WeatherNetworking(), context: ctx)
    }

    static var addOrGetCity: AddOrGetCityUseCase { AddOrGetCity(repo: repo) }
    static var fetchLatest:  FetchLatestWeatherUseCase { FetchLatestWeather(repo: repo) }
    static var getCityHistory:GetCityHistoryUseCase { GetCityHistory(repo: repo) }
    static var listCities:   ListCitiesUseCase { ListCities(repo: repo) }
    static var deleteCities: DeleteCitiesUseCase { DeleteCities(repo: repo) }
}
