//
//  Persistence.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 10/10/2025.
//

import CoreData

/// Minimal Core Data stack used by the app & tests.
struct PersistenceController {
    static let shared = PersistenceController()

    /// Convenience accessor for the main context.
    var viewContext: NSManagedObjectContext { container.viewContext }

    let container: NSPersistentContainer

    /// Name must match your `.xcdatamodeld` file (left pane shows: PlanRadarWeather.xcdatamodeld).
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PlanRadarWeather")
        if inMemory {
            // Use an in-memory store for previews/tests.
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error { fatalError("Core Data load error: \(error)") }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    /// Preview store for SwiftUI previews & unit tests.
    static let preview: PersistenceController = {
        let pc = PersistenceController(inMemory: true)
        let ctx = pc.viewContext

        // Seed a sample City + one WeatherInfo (optional)
        let city = City(context: ctx)
        city.id = UUID()
        city.name = "Cairo"
        city.createdAt = Date()

        let w = WeatherInfo(context: ctx)
        w.id = UUID()
        w.requestedAt = Date()
        w.summary = "clear sky"
        w.tempC = 27
        w.humidity = 40
        w.windSpeed = 3.6
        w.iconID = "01d"
        w.city = city

        try? ctx.save()
        return pc
    }()
}
