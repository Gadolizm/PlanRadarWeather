//
//  WeatherRepositoryImpl.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation
import CoreData

// Keep the protocol internal too (remove `public` from WeatherRepository).
final class WeatherRepositoryImpl: WeatherRepository {
    let networking: WeatherNetworking
    let context: NSManagedObjectContext

    // No default args → no access problems
    init(networking: WeatherNetworking, context: NSManagedObjectContext) {
        self.networking = networking
        self.context = context
    }
}

// Convenience factory to build the default wired instance
extension WeatherRepositoryImpl {
    static func live() -> WeatherRepositoryImpl {
        WeatherRepositoryImpl(
            networking: WeatherNetworking(),
            context: PersistenceController.shared.viewContext
        )
    }
}
