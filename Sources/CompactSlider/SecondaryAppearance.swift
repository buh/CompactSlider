// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct SecondaryAppearance {
    public let color: Color
    public var progressOpacity: Double = 0.075
    public var handleOpacity: Double = 0.2
    public var scaleOpacity: Double = 0.8
    public var smallScaleOpacity: Double = 0.3
}

struct CompactSliderSecondaryColorKey: EnvironmentKey {
    static var defaultValue = SecondaryAppearance(color: .label)
}

extension EnvironmentValues {
    var compactSliderSecondaryAppearance: SecondaryAppearance {
        get { self[CompactSliderSecondaryColorKey.self] }
        set { self[CompactSliderSecondaryColorKey.self] = newValue }
    }
}

// MARK: - View Extension

public extension View {
    /// Sets secondary colors for sliders within this view to a slider style.
    /// - Parameters:
    ///   - color: the secondary color.
    ///   - progressOpacity: the opacity for the progress view based on the secondary color.
    ///   - handleOpacity: the opacity for the handle view based on the secondary color.
    ///   - scaleOpacity: the opacity for the scale view based on the secondary color.
    ///   - smallScaleOpacity: the opacity for the small scale view based on the secondary color.
    func compactSliderSecondaryColor(
        _ color: Color,
        progressOpacity: Double = 0.075,
        handleOpacity: Double = 0.2,
        scaleOpacity: Double = 0.8,
        smallScaleOpacity: Double = 0.3
    ) -> some View {
        environment(
            \.compactSliderSecondaryAppearance,
             SecondaryAppearance(
                color: color,
                progressOpacity: progressOpacity,
                handleOpacity: handleOpacity,
                scaleOpacity: scaleOpacity,
                smallScaleOpacity: smallScaleOpacity
             )
        )
    }
}
