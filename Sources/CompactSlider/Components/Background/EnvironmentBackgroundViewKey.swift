// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct BackgroundViewKey: EnvironmentKey {
    static let defaultValue: (EdgeInsets) -> AnyView = { padding in
        BackgroundContainerView(padding: padding) {
            DefaultBackgroundView(configuration: $0, padding: $1)
        }
        .anyView()
    }
}

extension EnvironmentValues {
    public var compactSliderBackgroundView: (EdgeInsets) -> AnyView {
        get { self[BackgroundViewKey.self] }
        set { self[BackgroundViewKey.self] = newValue }
    }
}

// MARK: - View

extension View {
    /// Set a custom background view for the slider.
    ///
    /// - Parameter backgroundView: a custom background view. The view builder provides the configuration and padding.
    public func compactSliderBackground<V: View>(
        @ViewBuilder backgroundView: @escaping (
            _ configuration: CompactSliderStyleConfiguration,
            _ padding: EdgeInsets
        ) -> V
    ) -> some View {
        environment(
            \.compactSliderBackgroundView,
             { padding in
                 BackgroundContainerView(padding: padding) {
                     backgroundView($0, $1)
                 }
                 .anyView()
             }
        )
    }
}
