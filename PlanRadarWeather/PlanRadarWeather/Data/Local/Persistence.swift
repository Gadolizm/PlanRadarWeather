//
//  Persistence.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 10/10/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    var viewContext: NSManagedObjectContext { container.viewContext }
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = {
            // Try to load the active .mom (not the whole .momd)
            func currentModelURL(_ name: String, in bundle: Bundle) -> URL? {
                guard let momd = bundle.url(forResource: name, withExtension: "momd") else { return nil }
                let versionPlist = momd.appendingPathComponent("VersionInfo.plist")
                guard let data = try? Data(contentsOf: versionPlist),
                      let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
                      let current = plist["_XCCurrentVersionName"] as? String
                else { return nil }
                return momd.appendingPathComponent(current) // points to .mom
            }

            let modelName = "PlanRadarWeather"

            // Prefer loading from the main bundle
            if let url = currentModelURL(modelName, in: .main),
               let model = NSManagedObjectModel(contentsOf: url) {
                return NSPersistentContainer(name: modelName, managedObjectModel: model)
            } else {
                // Fallback: rely on default discovery (works if only one model is linked)
                return NSPersistentContainer(name: modelName)
            }
        }()

        // Use in-memory store automatically under XCTest or when requested
        let runningTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        if inMemory || runningTests {
            let desc = NSPersistentStoreDescription()
            desc.type = NSInMemoryStoreType
            desc.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [desc]
        }

        var loadError: Error?
        container.loadPersistentStores { _, error in loadError = error }
        if let e = loadError {
            // Surface a clear error instead of crashing on a nil unwrap
            fatalError("Core Data load error: \(e)")
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
