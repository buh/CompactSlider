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
        } else {
            Defaults.backgroundColor
        }
    }
}
