// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct SystemSliderStyleKey: EnvironmentKey {
    static let defaultValue: (slider: DefaultCompactSliderStyle, handle: HandleStyle?) = (
        DefaultCompactSliderStyle.horizontal(clipShapeStyle: .none), nil
    )
}

extension EnvironmentValues {
    var systemSliderStyle: (slider: DefaultCompactSliderStyle, handle: HandleStyle?) {
        get { self[SystemSliderStyleKey.self] }
        set { self[SystemSliderStyleKey.self] = newValue }
    }
}

extension View {
    /// Sets a style for the "system" slider. The style supports horizontal and vertical sliders.
    /// - Parameters:
    /// - type: The type of the "system" slider.
    /// - handleStyle: The style of the handle. Default is `nil`.
    /// - padding: The padding of the slider. Default is `.zero`.
    public func systemSliderStyle(
        _ type: SystemSliderType = .horizontal(.leading),
        handleStyle: HandleStyle? = nil,
        padding: EdgeInsets = .zero
    ) -> some View {
        environment(
            \.systemSliderStyle,
             (
                DefaultCompactSliderStyle(
                    type: type.compactSliderType,
                    clipShapeStyle: .capsule(options: [.background, .progress, .scale]),
                    padding: padding
                ),
                handleStyle
             )
        )
    }
}
