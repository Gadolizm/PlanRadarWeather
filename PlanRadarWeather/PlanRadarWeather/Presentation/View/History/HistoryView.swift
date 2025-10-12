//
//  HistoryView.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//

import SwiftUI


struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: CityDetailViewModel

    init(city: CityEntity) {
        _vm = StateObject(wrappedValue: CityDetailViewModel(city: city))
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            WavesBackground()

            VStack(spacing: 16) {
                // Top bar: left pill + centered two-line title + spacer to balance
                HStack(alignment: .center, spacing: 3) {
                    BackPillButton(action: { dismiss() }, width: 120)
                        .offset(x: -8, y: 22) 
                    VStack(spacing: 10) {
                        Text(vm.city.name.uppercased())
                        Text("HISTORICAL")
                    }
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .kerning(2.0)
                    .foregroundStyle(Color("PrimaryText").opacity(0.75))
                    .multilineTextAlignment(.center)
                    Spacer(minLength: 90) // balance the pill width on the right
                }
                .padding(.top, 8)

                // List of entries (custom-styled)
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.history, id: \.id) { w in
                            HistoryRow(item: w)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 8)
        }
        .task { vm.loadHistory() }
        .navigationBarHidden(true)
    }
}

#if DEBUG
// MARK: - Sample data for previews
private func sampleHistory() -> [WeatherSnapshot] {
    [
        WeatherSnapshot(requestedAt: Date().addingTimeInterval(-60*60*24*0),
                        summary: "Cloudy", tempC: 14, humidity: 45, windSpeed: 5.5, iconID: "03d"),
        WeatherSnapshot(requestedAt: Date().addingTimeInterval(-60*60*24*1),
                        summary: "Rainy",  tempC: 9,  humidity: 72, windSpeed: 7.1, iconID: "10d"),
        WeatherSnapshot(requestedAt: Date().addingTimeInterval(-60*60*24*2),
                        summary: "Sunny",  tempC: 22, humidity: 30, windSpeed: 3.3, iconID: "01d")
    ]
}




// MARK: - Screen preview (inject mocked VM)
#Preview("HistoryView • Light") {
    let city = CityEntity(name: "London, UK")
    HistoryView(city: city)
        .preferredColorScheme(.light)
}
#Preview("HistoryView — iPhone 15 Pro (Dark)"){
    let city = CityEntity(name: "London, UK")
    HistoryView(city: city)
        .preferredColorScheme(.dark)
}
#endif

