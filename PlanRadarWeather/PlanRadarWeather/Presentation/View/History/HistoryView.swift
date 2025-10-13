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
                        .accessibilityIdentifier(A11yID.historyTitle)
                    VStack(spacing: 10) {
                        Text(vm.city.name.uppercased())
                        Text("HISTORICAL")
                    }
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .kerning(2.0)
                    .foregroundStyle(Color("PrimaryText").opacity(0.75))
                    .multilineTextAlignment(.center)
                    .accessibilityIdentifier(A11yID.historyTitle)
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
