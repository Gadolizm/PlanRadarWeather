//
//  CityDetailViewModel.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import Foundation
import Combine

@MainActor
final class CityDetailViewModel: ObservableObject {
    @Published var latest: WeatherSnapshot?
    @Published var history: [WeatherSnapshot] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let fetchLatest: FetchLatestWeatherUseCase
    private let getHistory: GetCityHistoryUseCase
    let city: CityEntity
    
    init(city: CityEntity,
         fetchLatest: FetchLatestWeatherUseCase,
         getHistory: GetCityHistoryUseCase) {
        self.city = city
        self.fetchLatest = fetchLatest
        self.getHistory = getHistory
        loadHistory()
    }

    convenience init(city: CityEntity) {
        self.init(city: city,
                  fetchLatest: AppDI.fetchLatest,
                  getHistory: AppDI.getCityHistory)
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let snapshot = try await fetchLatest.run(city: city)
            latest = snapshot
            loadHistory()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadHistory() {
        do {
            history = try getHistory.run(city: city).newestFirst()
            latest = history.first
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
