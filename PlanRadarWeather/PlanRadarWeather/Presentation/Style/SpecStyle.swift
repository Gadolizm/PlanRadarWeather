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

import SwiftUI

/// Background that draws ONLY the "Background" asset.
/// - Fill whole screen by default (ignores safe areas).
/// - Or pass a fixed height to use it as a header.
/// - Choose .fill (default) or .fit.
struct WavesBackground: View {
    enum Mode { case fill, fit }
    
    var imageName: String = "Background"
    var mode: Mode = .fill
    var fixedHeight: CGFloat? = nil          // e.g. 220 for a header
    var opacity: Double = 1.0
    
    var body: some View {
        Group {
            if let ui = UIImage(named: imageName) {
                Image(uiImage: ui)
                    .resizable()
            }
        }
    }
    
}
    
#if DEBUG
    // Simple overlay that tells you whether the "Background" image is found.
    private struct WavesBackgroundPreview: View {
        var body: some View {
            ZStack {
                WavesBackground(mode: .fill, fixedHeight: 223)
                    .frame(maxWidth: .infinity)
                VStack {
                    Spacer()
                    Text(UIImage(named: "Background") != nil ? "Background: FOUND" : "Background: MISSING")
                        .font(.footnote.weight(.semibold))
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.bottom, 24)
                }
            }
        }
    }
    
    #Preview("Waves • Light") {
        WavesBackgroundPreview()
            .preferredColorScheme(.light)
    }
    
    #Preview("Waves • Dark") {
        WavesBackgroundPreview()
            .preferredColorScheme(.dark)
    }



#endif

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
