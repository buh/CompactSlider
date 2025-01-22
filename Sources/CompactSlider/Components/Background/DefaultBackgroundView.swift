// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct DefaultBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let configuration: CompactSliderStyleConfiguration
    let padding: EdgeInsets
    
    var body: some View {
        if configuration.type.isGrid {
            GridBackgroundView(configuration: configuration, padding: padding)
                .saturation(configuration.focusState.isFocused ? 1 : 0)
                .overlay(
                    RoundedRectangle(cornerRadius: Defaults.gridCornerRadius)
                        .stroke(
                            colorScheme == .dark ? Color.white.opacity(0.03) : .black.opacity(0.03),
                            lineWidth: 1
                        )
                        .padding(1)
                )
        } else if configuration.type.isCircularGrid {
            DefaultCircularGridBackgroundView(configuration: configuration)
        } else {
            Defaults.backgroundColor
        }
    }
}

struct DefaultCircularGridBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    let configuration: CompactSliderStyleConfiguration
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Defaults.label.opacity(0),
                        Defaults.label.opacity(0.01),
                        Defaults.label.opacity(0.1),
                        Defaults.label.opacity(0.3)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: configuration.size.minValue
                )
            )
            .overlay(
                CircularScale(
                    step: .degrees(
                        360 / Double(configuration.step?.polarPointSteps?.angle ?? 72).clamped(3, 120)
                    ),
                    minRadius: 0.9,
                    maxRadius: 0.95
                )
                .stroke(
                    configuration.focusState.isFocused
                    ? Color.accentColor
                    : (colorScheme == .dark ? Color.white.opacity(0.1) : .black.opacity(0.1)),
                    lineWidth: 1
                )
            )
            .overlay(
                Circle()
                    .stroke(
                        colorScheme == .dark ? Color.white.opacity(0.03) : .black.opacity(0.03),
                        lineWidth: 1
                    )
                    .padding(1)
            )
    }
}
