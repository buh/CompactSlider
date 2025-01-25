// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ScaleViewKey: EnvironmentKey {
    static var defaultValue: AnyView? = ScaleContainerView {
        DefaultScaleView(configuration: $0)
    }.anyView()
}

extension EnvironmentValues {
    var scaleView: AnyView? {
        get { self[ScaleViewKey.self] }
        set { self[ScaleViewKey.self] = newValue }
    }
}

// MARK: - View

extension View {
    public func compactSliderScale(
        visibility: CompactSliderVisibility = .handleDefault,
        alignment: Alignment,
        _ scaleViews: ScaleView...
    ) -> some View {
        if scaleViews.isEmpty {
            environment(\.scaleView, nil)
        } else {
            environment(
                \.scaleView,
                 ScaleContainerView(visibility: visibility) { configuration in
                     ScaleZStackView(alignment: alignment, scaleViews: scaleViews)
                 }
                .anyView()
            )
        }
    }
    
    public func compactSliderScale<ScaleView: View>(
        visibility: CompactSliderVisibility = .handleDefault,
        @ViewBuilder scaleView: @escaping (_ configuration: CompactSliderStyleConfiguration) -> ScaleView
    ) -> some View {
        environment(
            \.scaleView,
             ScaleContainerView(visibility: visibility) {
                 scaleView($0)
             }
             .anyView()
        )
    }
}
