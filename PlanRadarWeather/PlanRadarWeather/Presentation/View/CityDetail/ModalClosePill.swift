//
//  ModalClosePill.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//

import SwiftUI



struct ModalClosePill: View {
    var action: () -> Void
    var width: CGFloat = 124

    var body: some View {
        let ui = UIImage(named: "Button_modal")
        let ratio = (ui?.size.width ?? 248) / (ui?.size.height ?? 112)
        let height = width / ratio

        return Button(action: action) {
            ZStack {
                Image("Button_modal")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()

                GeometryReader { geo in
                    let h = geo.size.height
                    Image(systemName: "xmark")
                        .font(.system(size: min(22, h * 0.45), weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
                        // center of the round cap (visually perfect)
                        .position(x: h / 3, y: h / 3)
                }
            }
            .frame(width: width, height: height)
            .contentShape(Rectangle())
            .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 14)
            .shadow(color: .black.opacity(0.06), radius: 8,  x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Close")
    }
}
