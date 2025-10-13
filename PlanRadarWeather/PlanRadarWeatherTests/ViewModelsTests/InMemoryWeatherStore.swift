//
//  InMemoryWeatherStore.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 13/10/2025.
//


import XCTest
@testable import PlanRadarWeather

// MARK: - Tiny in-memory store the mocks close over

private final class InMemoryWeatherStore {
    var hist: [String: [WeatherSnapshot]] = [:]   // key = city.name

    func set(_ list: [WeatherSnapshot], for city: CityEntity) {
        hist[city.name] = list
    }
    func append(_ snap: WeatherSnapshot, for city: CityEntity) {
        hist[city.name, default: []].append(snap)
    }
    func history(for city: CityEntity) -> [WeatherSnapshot] {
        hist[city.name] ?? []
    }
}

// MARK: - Closure-based mocks that conform to your use cases

private struct FetchLatestWeatherUCMock: FetchLatestWeatherUseCase {
    let impl: (_ city: CityEntity) async throws -> WeatherSnapshot
    func run(city: CityEntity) async throws -> WeatherSnapshot { try await impl(city) }
}

private struct GetCityHistoryUCMock: GetCityHistoryUseCase {
    let impl: (_ city: CityEntity) throws -> [WeatherSnapshot]
    func run(city: CityEntity) throws -> [WeatherSnapshot] { try impl(city) }
}

// MARK: - Helpers

private func makeSnap(
    requestedAt: Date,
    summary: String = "clear sky",
    tempC: Double = 20,
    humidity: Double = 50,
    wind: Double = 3.6,
    icon: String = "01d"
) -> WeatherSnapshot {
    WeatherSnapshot(
        requestedAt: requestedAt,
        summary: summary,
        tempC: tempC,
        humidity: humidity,
        windSpeed: wind,
        iconID: icon
    )
}

@MainActor
final class CityDetailViewModelTests: XCTestCase {

    private func makeVM(
        cityName: String = "Paris, FR",
        seedHistory: [WeatherSnapshot] = []
    ) -> (vm: CityDetailViewModel, store: InMemoryWeatherStore) {

        let city = CityEntity(name: cityName)
        let store = InMemoryWeatherStore()
        store.set(seedHistory, for: city)

        let fetchMock = FetchLatestWeatherUCMock { city in
            // produce a new "latest" reading and append to store
            let snap = makeSnap(requestedAt: Date())
            store.append(snap, for: city)
            return snap
        }

        let historyMock = GetCityHistoryUCMock { city in
            store.history(for: city)
        }

        let vm = CityDetailViewModel(city: city, fetchLatest: fetchMock, getHistory: historyMock)
        return (vm, store)
    }

    // MARK: - Tests

    func test_init_loadsHistory_and_setsLatest_toNewest() {
        let old = makeSnap(requestedAt: Date().addingTimeInterval(-3600))
        let newer = makeSnap(requestedAt: Date())
        let (vm, _) = makeVM(seedHistory: [old, newer]) // unsorted on purpose

        // VM sorts newestFirst() internally
        XCTAssertEqual(vm.history.count, 2)
        XCTAssertEqual(vm.latest?.requestedAt, [old, newer].max(by: { $0.requestedAt < $1.requestedAt })?.requestedAt)
    }

    func test_refresh_appendsNewSnapshot_and_latestUpdates() async {
        let seed = makeSnap(requestedAt: Date().addingTimeInterval(-120))
        let (vm, store) = makeVM(seedHistory: [seed])

        let beforeCount = vm.history.count
        await vm.refresh()

        // store received one more snapshot through fetch mock
        XCTAssertEqual(store.history(for: vm.city).count, beforeCount + 1)
        // VM reloaded history and latest points to newest
        XCTAssertEqual(vm.history.count, beforeCount + 1)
        XCTAssertEqual(vm.latest?.requestedAt, vm.history.first?.requestedAt) // newestFirst()
    }

    func test_refresh_toggles_isLoading_flag() async {
        // fetch mock with a tiny delay to observe isLoading=true
        let city = CityEntity(name: "Vienna, AUT")
        let store = InMemoryWeatherStore()
        store.set([], for: city)

        let fetchMock = FetchLatestWeatherUCMock { _ in
            try await Task.sleep(nanoseconds: 80_000_000) // 80ms
            let snap = makeSnap(requestedAt: Date())
            store.append(snap, for: city)
            return snap
        }
        let historyMock = GetCityHistoryUCMock { _ in store.history(for: city) }

        let vm = CityDetailViewModel(city: city, fetchLatest: fetchMock, getHistory: historyMock)

        let task = Task { await vm.refresh() }
        // Give the main runloop a tick to set the flag
        await Task.yield()
        XCTAssertTrue(vm.isLoading, "isLoading should be true while refresh is in flight")

        _ = await task.value
        XCTAssertFalse(vm.isLoading, "isLoading should reset to false after refresh")
        XCTAssertNil(vm.errorMessage)
    }

    func test_refresh_error_setsErrorMessage_and_resetsLoading() async {
        let city = CityEntity(name: "Cairo, EG")
        let store = InMemoryWeatherStore()
        store.set([], for: city)

        enum TestErr: Error { case boom }
        let fetchMock = FetchLatestWeatherUCMock { _ in throw TestErr.boom }
        let historyMock = GetCityHistoryUCMock { _ in store.history(for: city) }

        let vm = CityDetailViewModel(city: city, fetchLatest: fetchMock, getHistory: historyMock)

        await vm.refresh()
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }
}