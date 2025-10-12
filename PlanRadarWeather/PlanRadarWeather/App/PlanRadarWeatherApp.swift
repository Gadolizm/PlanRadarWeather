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
            CitiesView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
