//
//  SpecStyle.swift
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


import SwiftUI

enum Spec {
    static let accent = Color("AccentColor")
    static let primary = Color("PrimaryText")
    static let secondary = Color("SecondaryText")

    static let cornerXL: CGFloat = 28
    static let cardCorner: CGFloat = 28
    static let shadow = Color.black.opacity(0.18)

    static let headerDF: DateFormatter = {
        let df = DateFormatter()
        df.locale = .init(identifier: "en_US_POSIX")
        df.dateFormat = "dd.MM.yyyy - HH:mm"
        return df
    }()
}

struct SpecTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .heavy, design: .rounded))
            .kerning(1.6)
            .foregroundStyle(Spec.primary)
            .textCase(.uppercase)
    }
}

extension View {
    func specTitle() -> some View { modifier(SpecTitle()) }
}


struct WavesBackground: View {
    var imageName: String = "Background"   // one asset name; add Dark variant in the same set

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // spec backdrop color (use your color asset if you already added it)
                Color("ScreenBG")

                if let ui = UIImage(named: imageName) {
                    Image(uiImage: ui)
                        .resizable()
                        .renderingMode(.original)   // prevent tinting
                        .interpolation(.high)
                        .scaledToFit()              // keep wave shape
                        .frame(width: geo.size.width)
                        .clipped()
                        .transition(.opacity)
                }
            }
            .ignoresSafeArea()
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

struct BigRoundButton: View {
    let systemName: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 88, height: 56)
                .background(Spec.accent)
                .clipShape(RoundedRectangle(cornerRadius: Spec.cornerXL, style: .continuous))
                .shadow(color: Spec.shadow, radius: 22, x: 0, y: 10)
        }
    }
}
