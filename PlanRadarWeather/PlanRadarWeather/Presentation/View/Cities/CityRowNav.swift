//
//  CityRowNav.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//


import SwiftUI

struct CityRowNav: View {
    let city: CityEntity
    let onNameTap: () -> Void
    let onArrowTap: () -> Void
    
    @Environment(\.colorScheme) private var scheme
    
    private var chevronColor: Color {
        scheme == .dark ? .red : Color("AccentColor")
    }

    var body: some View {
        
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Name area → Details
                Button(action: onNameTap) {
                    Text(city.name.uppercased())
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color("PrimaryText"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())

                // Arrow → Detail then History (handled in CitiesView)
                Button(action: onArrowTap) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(chevronColor)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }

            Divider()
                .overlay(Color.secondary.opacity(0.15))
                .padding(.leading, 24)
        }
    }
}
