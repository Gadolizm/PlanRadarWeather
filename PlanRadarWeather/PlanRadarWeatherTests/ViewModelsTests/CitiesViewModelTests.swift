//
//  CitiesViewModelTests.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 13/10/2025.
//

import XCTest
@testable import PlanRadarWeather

@MainActor
final class CitiesViewModelTests: XCTestCase {

    private func makeVM(seed: [String] = []) -> (CitiesViewModel, InMemoryStore) {
        let store = InMemoryStore()
        store.cities = seed.map { CityEntity(name: $0) }

        let add  = AddOrGetCityUCMock { name in
            if let ex = store.cities.first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) {
                return ex
            }
            let c = CityEntity(name: name); store.cities.append(c); return c
        }
        let list = ListCitiesUCMock { store.cities }
        let del  = DeleteCitiesUCMock { targets in
            let rm = Set(targets.map { $0.name.lowercased() })
            store.cities.removeAll { rm.contains($0.name.lowercased()) }
        }

        return (CitiesViewModel(addCity: add, listCities: list, deleteCities: del), store)
    }

    func test_addCity_ignoresBlankInput() {
        let (vm, store) = makeVM()
        vm.cityName = "   "
        vm.addCityAction()
        XCTAssertTrue(store.cities.isEmpty)   // no mutation
        XCTAssertNil(vm.errorMessage)
    }

    func test_addCity_addsAndResetsText() {
        let (vm, store) = makeVM()
        vm.cityName = "Vienna, AUT"
        vm.addCityAction()
        XCTAssertEqual(vm.cityName, "")
        XCTAssertTrue(store.cities.contains { $0.name == "Vienna, AUT" })
        XCTAssertTrue(vm.cities.contains { $0.name == "Vienna, AUT" })
        XCTAssertNil(vm.errorMessage)
    }
}
