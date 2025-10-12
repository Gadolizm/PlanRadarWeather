//
//  BackPillButton.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 12/10/2025.
//


import SwiftUI

struct BackPillButton: View {
    @Environment(\.colorScheme) private var colorScheme

    var action: () -> Void
    var width: CGFloat = 124

    var body: some View {
        let ui     = UIImage(named: "Button_left")
        let ratio  = (ui?.size.width ?? 248) / (ui?.size.height ?? 112)
        let height = width / ratio
        let arrow  = (colorScheme == .dark) ? Color.black : Color.white

        return Button(action: action) {
            ZStack {
                Image("Button_left")
                    .resizable()
                    .renderingMode(.original)   // keep asset colors
                    .interpolation(.high)
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()

                GeometryReader { geo in
                    let h = geo.size.height
                    Image(systemName: "arrow.left")
                        .font(.system(size: min(22, h * 0.45), weight: .bold))
                        .foregroundStyle(arrow)
                        .position(x: h / 4, y: h / 3)
                }
            }
            .frame(width: width, height: height)
            .contentShape(Rectangle())

        }
        .buttonStyle(.plain)
        .accessibilityLabel("Back")
    }
}

// MARK: - Back pill preview
#Preview("BackPillButton") {
    BackPillButton(action: {})
        .padding()
        .background(Color(.systemBackground))
}
