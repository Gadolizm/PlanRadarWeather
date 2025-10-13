//
//  CityRow.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import SwiftUI

struct CityRow: View {
    let title: String
    @Environment(\.colorScheme) private var scheme

    private var chevronColor: Color {
        scheme == .dark ? .red : Color("AccentColor")
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title.uppercased())
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color("PrimaryText"))
                    .accessibilityIdentifier(A11yID.cityRow(title))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(chevronColor)
            }
            .padding(.vertical, 16)

            Divider()
                .overlay(Color.secondary.opacity(0.15))
                .padding(.leading, 24)
        }
        .contentShape(Rectangle())
    }
}
