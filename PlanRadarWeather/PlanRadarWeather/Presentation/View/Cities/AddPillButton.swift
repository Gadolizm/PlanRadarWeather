//
//  AddPillButton.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import SwiftUI

struct AddPillButton: View {
    var action: () -> Void
    var width: CGFloat = 90
    /// Nudge the plus to compensate for PNG padding/shadow.
    var glyphOffset: CGSize = .init(width: 15, height: -15) // tweak if needed

    var body: some View {
        // Keep the image's true aspect ratio → no stretching
        let ui = UIImage(named: "Button_right")
        let ratio = (ui?.size.height ?? 56) / (ui?.size.width ?? 108)
        let height = width * ratio

        return Button(action: action) {
            ZStack {
                Image("Button_right")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)

                Image(systemName: "plus")
                    .font(.system(size: min(24, height * 0.45), weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
                    .offset(glyphOffset) // << centers it optically
            }
            .frame(width: width, height: height)
            .contentShape(Rectangle())
            .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 14)
            .shadow(color: .black.opacity(0.06), radius: 8,  x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add city")
    }
}
