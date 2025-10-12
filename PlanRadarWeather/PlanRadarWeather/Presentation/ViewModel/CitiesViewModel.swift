//
//  CitiesViewModel.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation
import Combine

@MainActor
final class CitiesViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var cities: [CityEntity] = []
    @Published var errorMessage: String?

    private let addCity: AddOrGetCityUseCase
    private let listCities: ListCitiesUseCase
    private let deleteCities: DeleteCitiesUseCase

    // Designated init (no defaults)
    init(addCity: AddOrGetCityUseCase,
         listCities: ListCitiesUseCase,
         deleteCities: DeleteCitiesUseCase) {
        self.addCity = addCity
        self.listCities = listCities
        self.deleteCities = deleteCities
        reload()
    }
    
    // Convenience init uses AppDI on the main actor
    convenience init() {
        self.init(addCity: AppDI.addOrGetCity,
                  listCities: AppDI.listCities,
                  deleteCities: AppDI.deleteCities)
    }

    func addCityAction() {
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        do {
            _ = try addCity.run(name: trimmed)
            cityName = ""
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(at offsets: IndexSet) {
        let targets = offsets.map { cities[$0] }
        do {
            try deleteCities.run(targets)
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func reload() {
        do {
            cities = try listCities.run()
            if cities.isEmpty {
                cities = [
                    CityEntity(name: "London, UK"),
                    CityEntity(name: "Paris, FR"),
                    CityEntity(name: "Vienna, AUT")
                ]
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
