// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressViewKey: EnvironmentKey {
    static let defaultValue: AnyView =
        ProgressContainerView { configuration in
            ProgressView(
                focusState: configuration.focusState,
                fillStyle: Defaults.progressColor,
                focusedFillStyle: Defaults.focusedProgressColor
            )
        }
        .anyView()
}

extension EnvironmentValues {
    var compactSliderProgressView: AnyView {
        get { self[ProgressViewKey.self] }
        set { self[ProgressViewKey.self] = newValue }
    }
}

// MARK: - View

extension View {
    /// Sets a custom progress view for the slider.
    ///
    /// - Parameters:
    ///  - progressView: a custom progress view.
    public func compactSliderProgress<V: View>(
        @ViewBuilder progressView: @escaping (_ configuration: CompactSliderStyleConfiguration) -> V
    ) -> some View {
        environment(
            \.compactSliderProgressView,
             ProgressContainerView {
                 progressView($0)
             }
            .anyView()
        )
    }
}
