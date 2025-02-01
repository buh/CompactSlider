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
    /// Compose a scale view for the compact slider, using a set of scale shape styles.
    ///
    /// - Parameters:
    ///  - visibility: The visibility of the scale view.
    ///  - alignment: The alignment of the scale view.
    ///  - scaleShapeStyles: The list of scale shape styles.
    public func compactSliderScale(
        visibility: CompactSliderVisibility = .default,
        alignment: Alignment = .center,
        _ scaleShapeStyles: ScaleShapeStyle...
    ) -> some View {
        if scaleShapeStyles.isEmpty {
            environment(\.scaleView, nil)
        } else {
            environment(
                \.scaleView,
                 ScaleContainerView(visibility: visibility) { configuration in
                     ScaleZStackView(
                        configuration: configuration,
                        alignment: alignment,
                        shapeStyles: scaleShapeStyles
                     )
                 }
                .anyView()
            )
        }
    }
    
    /// Sets a custom scale view for the slider.
    ///
    /// - Parameters:
    ///  - visibility: The visibility of the scale view.
    ///  - scaleView: The custom scale view.
    public func compactSliderScale<ScaleView: View>(
        visibility: CompactSliderVisibility = .default,
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
