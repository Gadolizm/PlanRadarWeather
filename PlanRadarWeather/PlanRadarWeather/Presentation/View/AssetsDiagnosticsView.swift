//
//  AssetsDiagnosticsView.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import SwiftUI

struct AssetsDiagnosticsView: View {
    private let images = ["Background", "Button_right", "Button_left", "Button_modal"]
    private let colors = ["AccentColor", "PrimaryText", "SecondaryText"]

    var body: some View {
        List {
            Section("Images") {
                ForEach(images, id: \.self) { n in
                    HStack {
                        Text(n)
                        Spacer()
                        Image(systemName: UIImage(named: n) != nil ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .foregroundStyle(UIImage(named: n) != nil ? .green : .red)
                    }
                }
            }
            Section("Colors") {
                ForEach(colors, id: \.self) { n in
                    HStack {
                        Text(n).frame(width: 140, alignment: .leading)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(UIColor(named: n) ?? .clear))
                            .frame(width: 120, height: 24)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(.gray.opacity(0.3)))
                        Spacer()
                        Image(systemName: UIColor(named: n) != nil ? "checkmark.circle.fill" : "xmark.octagon.fill")
                            .foregroundStyle(UIColor(named: n) != nil ? .green : .red)
                    }
                }
            }
        }
        .navigationTitle("Assets Check")
    }
}

#if DEBUG
#Preview("Assets Check") { AssetsDiagnosticsView() }
#endif