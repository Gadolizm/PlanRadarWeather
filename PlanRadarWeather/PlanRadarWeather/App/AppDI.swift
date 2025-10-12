//
//  AppDI.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import CoreData

/// Builds real implementations once, so the rest of the app can reuse them.
enum AppDI {
    // Data layer (concrete repo that talks to Obj-C networking + Core Data)
    static let repo = WeatherRepositoryImpl(
        networking: WeatherNetworking(),
        context: PersistenceController.shared.viewContext
    )

    // Domain use cases (thin orchestrators)
    static let addOrGetCity    = AddOrGetCity(repo: repo)
    static let fetchLatest     = FetchLatestWeather(repo: repo)
    static let getCityHistory  = GetCityHistory(repo: repo)
    static let listCities      = ListCities(repo: repo)
    static let deleteCities    = DeleteCities(repo: repo)
}