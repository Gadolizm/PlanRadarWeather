//
//  WeatherRepositoryImpl+Weather.swift.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//

import Foundation
import CoreData

extension WeatherRepositoryImpl {
    public func fetchAndStoreLatest(for city: CityEntity) async throws -> WeatherSnapshot {
        // 1) Remote fetch
        let data = try await networking.fetchRaw(city: city.name)

        // 2) Decode API model
        let api: OWResponse
        do {
            api = try JSONDecoder().decode(OWResponse.self, from: data)
        } catch {
            // 200 but structure unexpected → surface a readable error
            throw AppError.httpStatus(code: 200, reason: "Decoding failed",
                                      bodyPreview: String(describing: error))
        }

        // 3) Map to Domain snapshot
        let snap = api.toDomainSnapshot()

        // 4) Persist
        var persisted: WeatherSnapshot!
        try await context.perform {
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
            persisted = w.toDomain()
        }
        return persisted
    }

    public func history(for city: CityEntity) throws -> [WeatherSnapshot] {
        var list: [WeatherSnapshot] = []
        try context.performAndWait {
            let req: NSFetchRequest<WeatherInfo> = WeatherInfo.fetchRequest()
            req.predicate = NSPredicate(format: "city.name =[c] %@", city.name)
            req.sortDescriptors = [NSSortDescriptor(key: "requestedAt", ascending: false)]
            list = try context.fetch(req).map { $0.toDomain() }
        }
        return list
    }
}
