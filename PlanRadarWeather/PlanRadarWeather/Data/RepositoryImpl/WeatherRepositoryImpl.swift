//
//  WeatherRepositoryImpl.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation
import CoreData

final class WeatherRepositoryImpl: WeatherRepository {
    let networking: WeatherNetworking
    let context: NSManagedObjectContext

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
