//
//  CityDetailView.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import SwiftUI

struct CityDetailView: View {
    let city: CityEntity
    // TEMP demo data until wired
    var snapshot: WeatherSnapshot = .init(
        summary: "Cloudy", tempC: 20, humidity: 45, windSpeed: 20, iconID: "02d"
    )

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack(alignment: .topLeading) {



            // ── Content card + footer ────────────────────────────────────────────
            VStack(spacing: 20) {
                Spacer().frame(height: 96)

                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .fill(cardFill)
                    .shadow(color: .black.opacity(scheme == .dark ? 0.55 : 0.18),
                            radius: scheme == .dark ? 30 : 24, x: 0, y: 12)
                    .overlay(cardContent.padding(28))
                    .frame(maxWidth: .infinity, minHeight: 360)
                    .padding(.horizontal, 24)

                Text("WEATHER INFORMATION FOR \(city.name.uppercased()) RECEIVED ON\n\(formatted(snapshot.requestedAt))")
                    .font(.footnote.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Spacer()
            }
        }
        // Top centered title
        .overlay(alignment: .top) {
            Text(city.name.uppercased())
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .kerning(2.0)
                .foregroundStyle(Color("PrimaryText").opacity(0.75))
                .padding(.top, 18)
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier(A11yID.detailsCard)

        }

        // Top-left close pill
        .overlay(alignment: .topLeading) {
            ModalClosePill(action: { dismiss() }, width: 124)
                .accessibilityIdentifier(A11yID.modalClose)
                .padding(.leading, 2)

                .offset(x: -15, y: -16)       
        }
        .navigationBarBackButtonHidden(true)
    }

    // Card interior
    private var cardContent: some View {
        VStack(spacing: 24) {
            // Icon (SF Symbol stand-in)
            Image(systemName: sfSymbol(for: snapshot.iconID))
                .font(.system(size: 88, weight: .regular))
                .foregroundStyle(Color("AccentColor"))

            VStack(spacing: 22) {
                specRow(label: "DESCRIPTION", value: snapshot.summary)
                specRow(label: "TEMPERATURE", value: snapshot.tempCString)
                specRow(label: "HUMIDITY", value: snapshot.humidityString)
                specRow(label: "WINDSPEED", value: "\(Int(round(snapshot.windSpeed * 3.6))) km/h")
            }
        }
    }

    // One spec row
    private func specRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Color("PrimaryText").opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundStyle(Color("AccentColor")) // blue in light, red in dark via asset
        }
    }

    private var cardFill: some ShapeStyle {
        scheme == .dark
        ? AnyShapeStyle(Color(.secondarySystemBackground).opacity(0.75))
        : AnyShapeStyle(Color(.systemBackground))
    }

    private func sfSymbol(for id: String) -> String {
        switch id {
        case "01d","01n": return "sun.max.fill"
        case "02d","02n": return "cloud.sun.fill"
        case "03d","03n","04d","04n": return "cloud.fill"
        case "09d","09n","10d","10n": return "cloud.rain.fill"
        case "11d","11n": return "cloud.bolt.fill"
        case "13d","13n": return "cloud.snow.fill"
        case "50d","50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }

    private func formatted(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = .init(identifier: "en_US_POSIX")
        df.dateFormat = "dd.MM.yyyy - HH:mm"
        return df.string(from: date)
    }
}
