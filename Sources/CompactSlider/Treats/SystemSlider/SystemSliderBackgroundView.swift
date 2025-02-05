// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A "system" slider background view.
public struct SystemSliderBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    let configuration: CompactSliderStyleConfiguration
    
    /// Create a "system" slider background view.
    ///
    /// - Parameter configuration: a configuration of the slider.
    public init(configuration: CompactSliderStyleConfiguration) {
        self.configuration = configuration
    }
    
    public var body: some View {
        #if os(visionOS)
        Capsule()
            .fill(
                LinearGradient(
                    colors: [.black.opacity(0.5), .black.opacity(0.1)],
                    startPoint: configuration.type.isHorizontal ? .top : .leading,
                    endPoint: configuration.type.isHorizontal ? .bottom : .trailing
                )
            )
            .background {
                Capsule()
                    .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                    .padding(.top, 1)
            }
        #else
        Capsule().fill(
            Defaults.labelColor.opacity(colorScheme == .dark ? 0.15 : 0.07)
        )
        #endif
    }
}
