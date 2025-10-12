//
//  WeatherRepositoryImpl+TestStore.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//

import Foundation
import CoreData
@testable import PlanRadarWeather

extension WeatherRepositoryImpl {
    /// TEST-ONLY: Decode OW JSON and persist like `fetchAndStoreLatest`, but without networking.
    func _test_storeDecoded(_ data: Data, for city: CityEntity) throws -> WeatherSnapshot {
        let api = try JSONDecoder().decode(OWResponse.self, from: data)
        let snap = api.toDomainSnapshot()

        var out: WeatherSnapshot!
        try context.performAndWait {
            let cityMO = try self.fetchOrCreateCityMO(byName: city.name)
            let w = WeatherInfo(context: self.context)
            w.id = UUID()
            w.requestedAt = Date()
            w.summary = snap.summary
            w.tempC = snap.tempC
            w.humidity = snap.humidity
            w.windSpeed = snap.windSpeed
            w.iconID = snap.iconID
            w.city = cityMO
            try self.context.save()
            out = w.toDomain()
        }
        return out
    }
}
