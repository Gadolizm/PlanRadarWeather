//
//  PlanRadarWeatherApp.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 10/10/2025.
//

import SwiftUI
import CoreData


@main
struct PlanRadarWeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if Runtime.isUnitTests {
                Text("Running Unit Tests") // tiny stub view for unit tests
            } else {
                CitiesView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

// Runtime.swift (app target)
enum Runtime {
    static var isUITests: Bool {
        ProcessInfo.processInfo.arguments.contains("-uiTesting")
    }
    static var isUnitTests: Bool {
        // Unit tests set this env var; UI tests also do, so exclude when -uiTesting is present
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil && !isUITests
    }
}
