// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ScaleViewKey: EnvironmentKey {
    static let defaultValue: AnyView? = ScaleContainerView {
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
    /// Compose the default scale view for the compact slider.
    ///
    /// - Parameters:
    ///  - visibility: The visibility of the scale view.
    ///  - alignment: The alignment of the scale view.
    ///  - scaleShapeStyles: The list of scale shape styles.
    ///  - lineLength: The length of the scale lines.
    ///  - strokeStyle: The stroke style of the scale lines.
    ///  - color: The color of the scale lines.
    ///  - secondaryColor: The secondary color of the scale lines.
    public func compactSliderScale(
        visibility: CompactSliderVisibility = .default,
        alignment: Alignment = .center,
        lineLength: CGFloat = Defaults.scaleLineLength,
        strokeStyle: StrokeStyle = .init(lineWidth: 1),
        color: Color = Defaults.scaleLineColor,
        secondaryColor: Color = Defaults.secondaryScaleLineColor
    ) -> some View {
        environment(
            \.scaleView,
             ScaleContainerView(visibility: visibility) { configuration in
                 DefaultScaleView(
                    alignment: alignment,
                    lineLength: lineLength,
                    strokeStyle: strokeStyle,
                    color: color,
                    secondaryColor: secondaryColor,
                    configuration: configuration
                 )
             }
            .anyView()
        )
    }
    
    /// Compose a scale view for the compact slider, using a set of scale shape styles.
    ///
    /// - Parameters:
    ///  - visibility: The visibility of the scale view.
    ///  - alignment: The alignment of the scale view.
    ///  - scaleShapeStyles: The list of scale shape styles.
    @ViewBuilder
    public func compactSliderScaleStyles(
        visibility: CompactSliderVisibility = .default,
        alignment: Alignment = .center,
        _ scaleShapeStyles: ScaleShapeStyle...
    ) -> some View {
        if scaleShapeStyles.isEmpty {
            self
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
    /// - Note: The scale will be duplicated if the `loopValues` option is enabled.
    /// 
    /// - Parameters:
    ///  - visibility: The visibility of the scale view.
    ///  - scaleView: The custom scale view.
    public func compactSliderScaleView<ScaleView: View>(
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
