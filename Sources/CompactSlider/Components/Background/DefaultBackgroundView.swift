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
            #if os(watchOS)
            let backgroundColor: Color? = Color(white: 0.05)
            #else
            let backgroundColor: Color? = nil
            #endif
            
            GridBackgroundView(
                configuration: configuration,
                padding: padding,
                backgroundColor: backgroundColor
            )
            .saturation(configuration.focusState.isFocused ? 1 : 0)
            .overlay(
                RoundedRectangle(cornerRadius: Defaults.gridCornerRadius)
                    #if os(watchOS)
                    .stroke(Color.white.opacity(0.08))
                    #else
                    .stroke(
                        colorScheme == .dark
                            ? Color.white.opacity(0.03)
                            : .black.opacity(0.03),
                        lineWidth: 1
                    )
                    #endif
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
    
    var gradientColors: [Color] {
        #if os(watchOS)
        [
            Defaults.labelColor.opacity(0),
            Defaults.labelColor.opacity(0.05),
            Defaults.labelColor.opacity(0.15),
            Defaults.labelColor.opacity(0.5)
        ]
        #else
        [
            Defaults.labelColor.opacity(0),
            Defaults.labelColor.opacity(0.01),
            Defaults.labelColor.opacity(0.1),
            Defaults.labelColor.opacity(0.3)
        ]
        #endif
    }
    
    var defaultScaleColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : .black.opacity(0.1)
    }
    
    var scaleColor: Color {
        configuration.focusState.isFocused ? Color.accentColor : defaultScaleColor
    }
    
    var centerCircleColor: Color {
        #if os(watchOS)
        configuration.progress.polarPoint.normalizedRadius == 0 ? .accentColor : .white.opacity(0.5)
        #else
        configuration.progress.polarPoint.normalizedRadius == 0
            ? .accentColor
            : (colorScheme == .dark ? Color.white.opacity(0.3) : .black.opacity(0.3))
        #endif
    }
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: gradientColors,
                    center: .center,
                    startRadius: 0,
                    endRadius: configuration.size.minValue
                )
            )
            .background(
                Circle().fillUltraThinMaterial()
            )
            .overlay(
                CircularScaleShape(
                    step: .degrees(
                        360 / Double(configuration.step?.polarPointSteps?.angle ?? 8).clamped(3, 120)
                    ),
                    minRadius: 0.9,
                    maxRadius: 0.95
                )
                .stroke(scaleColor, lineWidth: 1)
            )
            .overlay {
                if configuration.focusState.isDragging,
                   configuration.progress.polarPoint.normalizedRadius < 0.2 {
                    Circle()
                        .stroke(
                            centerCircleColor,
                            style: .init(lineWidth: 1, dash: [1, 4])
                        )
                        .frame(width: 30, height: 30)
                }
            }
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
