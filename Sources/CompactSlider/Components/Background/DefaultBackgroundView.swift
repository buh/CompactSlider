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
                            lineWidth: 2
                        )
                        .padding(1)
                )
        } else if configuration.type.isCircularGrid {
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
                    Circle()
                        .stroke(
                            colorScheme == .dark ? Color.white.opacity(0.03) : .black.opacity(0.03),
                            lineWidth: 2
                        )
                        .padding(1)
                )
        } else {
            Defaults.backgroundColor
        }
    }
}
