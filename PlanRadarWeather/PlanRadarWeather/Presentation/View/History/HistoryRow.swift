//
//  HistoryRow.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//

import SwiftUI


struct HistoryRow: View {
    let item: WeatherSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Self.dateDF.string(from: item.requestedAt))
                .font(.system(size: 13, weight: .semibold))
                .kerning(1.0)
                .foregroundStyle(Color("PrimaryText"))

            Text("\(item.summary.capitalized), \(Int(round(item.tempC)))°C")
                .font(.system(size: 22, weight: .heavy))
                .kerning(0.8)
                .foregroundStyle(Color("AccentColor"))
                .padding(.bottom, 6)

            Divider()
                .overlay(Color.secondary.opacity(0.15))
                .padding(.leading, 8) // inset like the spec
        }
        .padding(.vertical, 12)
    }

    private static let dateDF: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy - HH:mm"
        return f
    }()
}
