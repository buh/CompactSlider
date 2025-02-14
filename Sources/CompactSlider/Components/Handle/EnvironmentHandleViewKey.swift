// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct HandleViewKey: EnvironmentKey {
    static let defaultValue: AnyView =
        HandleViewContainerView { configuration, style, _, _ in
            HandleView(configuration: configuration, style: style)
        }
        .anyView()
}

extension EnvironmentValues {
    var compactSliderHandleView: AnyView {
        get { self[HandleViewKey.self] }
        set { self[HandleViewKey.self] = newValue }
    }
}

// MARK: - View

extension View {
    /// Set a custom handle view for the slider.
    ///
    /// - Parameter handleView: a custom handle view. The view builder provides the configuration,
    ///                         style, progress, and index. The index is the index of the handle for multiple handles.
    public func compactSliderHandle<V: View>(
        @ViewBuilder handleView: @escaping (
            _ configuration: CompactSliderStyleConfiguration,
            _ handleStyle: HandleStyle,
            _ progress: Double,
            _ index: Int
        ) -> V
    ) -> some View {
        environment(
            \.compactSliderHandleView,
             HandleViewContainerView {
                 handleView($0, $1, $2, $3)
             }
             .anyView()
        )
    }
}
