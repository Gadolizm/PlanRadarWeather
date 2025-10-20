//
//  CitiesView.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//

import SwiftUI

struct CitiesView: View {
    @StateObject private var vm = CitiesViewModel()
    @State private var showAdd = false
    @State private var path: [Route] = []

    private var rows: [CityEntity] {
        vm.cities.isEmpty
        ? [CityEntity(name: "London, UK"),
           CityEntity(name: "Paris, FR"),
           CityEntity(name: "Vienna, AUT")]
        : vm.cities
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .topTrailing) {
                
                WavesBackground() // optional; remove if you don’t have it


                ScrollView {
                    VStack(spacing: 0) {
                        Text("CITIES")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .kerning(1.6)
                            .foregroundStyle(Color("PrimaryText"))
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                            .accessibilityIdentifier(A11yID.citiesTitle)

                        VStack(spacing: 0) {
                            ForEach(rows, id: \.id) { city in
                                CityRowNav(
                                    city: city,
                                    onNameTap: { path.append(.detail(city)) },
                                    onArrowTap: { path.append(contentsOf: [.detail(city), .history(city)]) }
                                )
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.top, 8)
                    }
                }

                AddPillButton { showAdd = true }
                    .padding(.top, 24)
                    .padding(.trailing, 16)
                    .offset(x: 16, y: -35)
                    .accessibilityIdentifier(A11yID.addPill)
            }
            .navigationBarTitleDisplayMode(.inline)
            // Destinations
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detail(let city):
                    CityDetailView(city: city)
                case .history(let city):
                    HistoryView(city: city) // your custom back pill pops one → Details
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            AddCitySheet { name in
                vm.cityName = name
                vm.addCityAction()
            }
        }
    }
}
