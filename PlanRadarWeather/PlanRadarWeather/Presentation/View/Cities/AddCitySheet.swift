//
//  AddCitySheet.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import SwiftUI

struct AddCitySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    let onSave: (String) -> Void

    var body: some View {
        ZStack {
            WavesBackground() // optional; remove if you don’t have it
            VStack(spacing: 16) {
                Text("Enter city, postcode or airport location")
                    .font(.headline).multilineTextAlignment(.center)

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Search", text: $text)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 10)
                        .accessibilityIdentifier(A11yID.addTextField)
                }
                .padding(.horizontal, 12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))

                HStack {
                    Button("Cancel") { dismiss() }
                    Spacer()
                    Button("Save") {
                        onSave(text.trimmingCharacters(in: .whitespacesAndNewlines))
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(UIColor(named: "BrandAccent") ?? .systemBlue))
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding(20)
        }
        .presentationDetents([.medium, .large])
    }
}
