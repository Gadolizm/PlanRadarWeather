//
//  WeatherRepositoryImpl+Cities.swift
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
    
    public func ensureCity(named raw: String) throws -> CityEntity {
        let name = CityEntity.normalizeName(raw)
        var result: CityEntity!
        try context.performAndWait {
            let req: NSFetchRequest<City> = City.fetchRequest()
            req.fetchLimit = 1
            req.predicate = NSPredicate(format: "name ==[c] %@", name)

            if let existing = try context.fetch(req).first {
                result = existing.toDomain()
            } else {
                let c = makeCity()
                c.id = UUID()
                c.name = name
                c.createdAt = Date()
                try context.save()
                result = c.toDomain()
            }
        }
        return result
    }

    public func allCities() throws -> [CityEntity] {
        var list: [CityEntity] = []
        try context.performAndWait {
            let req: NSFetchRequest<City> = City.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            list = try context.fetch(req).map { $0.toDomain() }
        }
        return list
    }

    public func deleteCities(_ cities: [CityEntity]) throws {
        try context.performAndWait {
            let names = cities.map { $0.name.lowercased() }
            let req: NSFetchRequest<City> = City.fetchRequest()
            req.predicate = NSPredicate(format: "LOWER(name) IN %@", names)
            try context.fetch(req).forEach { context.delete($0) }
            try context.save()
        }
    }

    // MARK: - Private
    func fetchOrCreateCityMO(byName name: String) throws -> City {
        let req: NSFetchRequest<City> = City.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "name ==[c] %@", name)
        if let existing = try context.fetch(req).first { return existing }

        let c = makeCity()
        c.id = UUID()
        c.name = name
        c.createdAt = Date()
        return c
    }
}
