//
//  WeatherRepositoryImplTests.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//


import XCTest
import CoreData
@testable import PlanRadarWeather

final class WeatherRepositoryImplTests: XCTestCase {

    // MARK: - ensureCity / allCities / deleteCities

    func test_ensureCity_creates_then_returns_existing_caseInsensitive() throws {
        let container = TestCD.inMemoryContainer()
        let ctx = container.viewContext
        let repo = WeatherRepositoryImpl(networking: WeatherNetworking(), context: ctx)

        // First call creates
        let c1 = try repo.ensureCity(named: "Vienna, AUT")
        XCTAssertEqual(c1.name, "Vienna, AUT")

        // Second call (case-insensitive) returns existing
        let c2 = try repo.ensureCity(named: "vienna, aut")
        XCTAssertEqual(c2.id, c1.id)
        XCTAssertEqual(c2.name, "Vienna, AUT")

        // allCities contains exactly one
        let all = try repo.allCities()
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all.first?.name, "Vienna, AUT")
    }

    func test_allCities_sortedByCreatedAt_ascending() throws {
        let container = TestCD.inMemoryContainer()
        let ctx = container.viewContext
        let repo = WeatherRepositoryImpl(networking: WeatherNetworking(), context: ctx)

        _ = try repo.ensureCity(named: "A")
        // slight delay to ensure createdAt differs
        usleep(30_000)
        _ = try repo.ensureCity(named: "B")
        let list = try repo.allCities()
        XCTAssertEqual(list.map(\.name), ["A","B"])
    }

    func test_deleteCities_removesMatchingNames_caseInsensitive() throws {
        let container = TestCD.inMemoryContainer()
        let ctx = container.viewContext
        let repo = WeatherRepositoryImpl(networking: WeatherNetworking(), context: ctx)

        let a = try repo.ensureCity(named: "London")
        _ = try repo.ensureCity(named: "Paris")
        _ = try repo.ensureCity(named: "Vienna")

        try repo.deleteCities([CityEntity(name: "london")]) // lowercased input
        let remaining = try repo.allCities().map(\.name).sorted()
        XCTAssertEqual(remaining, ["Paris","Vienna"])
        XCTAssertNotEqual(a.name.lowercased(), remaining.first?.lowercased())
    }

    // MARK: - history / persist (without network)

    func test_storeDecoded_persists_and_history_returns_newestFirst() throws {
        let container = TestCD.inMemoryContainer()
        let ctx = container.viewContext
        let repo = WeatherRepositoryImpl(networking: WeatherNetworking(), context: ctx)
        let city = CityEntity(name: "Paris, FR")

        // persist 2 entries (pretend two fetches)
        let first = try repo._test_storeDecoded(JSONFixtures.owOK, for: city)
        // simulate later reading
        usleep(40_000)
        _ = try repo._test_storeDecoded(JSONFixtures.owOK, for: city)

        // domain fields mapped
        XCTAssertEqual(first.summary, "clear sky")
        XCTAssertEqual(first.iconID, "01d")
        XCTAssertEqual(first.humidity, 50)
        XCTAssertEqual(first.windSpeed, 3.6, accuracy: 0.0001)
        XCTAssertEqual(first.tempC, 20.0, accuracy: 0.001)

        // newest-first history
        let hist = try repo.history(for: city)
        XCTAssertEqual(hist.count, 2)
        XCTAssertTrue(hist[0].requestedAt >= hist[1].requestedAt)
    }
}
