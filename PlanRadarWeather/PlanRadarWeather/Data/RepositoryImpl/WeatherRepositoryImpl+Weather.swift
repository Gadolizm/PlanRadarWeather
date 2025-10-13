//
//  WeatherRepositoryImpl+Weather.swift.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//

import Foundation
import CoreData

extension WeatherRepositoryImpl {

    private func makeCity() -> City {
        NSEntityDescription.insertNewObject(forEntityName: "City", into: context) as! City
    }

    private func makeWeatherInfo() -> WeatherInfo {
        NSEntityDescription.insertNewObject(forEntityName: "WeatherInfo", into: context) as! WeatherInfo
    }
    
    public func fetchAndStoreLatest(for city: CityEntity) async throws -> WeatherSnapshot {
        let data = try await networking.fetchRaw(city: city.name)
        let api = try JSONDecoder().decode(OWResponse.self, from: data)
        let snap = api.toDomainSnapshot()

        var persisted: WeatherSnapshot!
        try await context.perform {
            let cityMO = try self.fetchOrCreateCityMO(byName: city.name)
            let w = self.makeWeatherInfo()
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
