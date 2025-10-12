//
//  TestCoreData.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//


import CoreData
@testable import PlanRadarWeather


enum TestCD {
    static func inMemoryContainer() -> NSPersistentContainer {
        // Load the .xcdatamodeld from the module that contains City/WeatherInfo
        // (This avoids “model not found / class not found” crashes.)
        guard let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: City.self)]) else {
            fatalError("❌ Could not load NSManagedObjectModel for City")
        }

        let container = NSPersistentContainer(name: "PlanRadarWeather", managedObjectModel: model)
        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType                 // no files, no flakiness
        desc.shouldAddStoreAsynchronously = false       // load synchronously to catch errors
        container.persistentStoreDescriptions = [desc]

        var loadError: Error?
        container.loadPersistentStores { _, error in loadError = error }
        if let e = loadError { fatalError("❌ loadPersistentStores failed: \(e)") }

        let ctx = container.viewContext
        ctx.automaticallyMergesChangesFromParent = true
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }
}
