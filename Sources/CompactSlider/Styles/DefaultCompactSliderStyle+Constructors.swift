// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public extension DefaultCompactSliderStyle {
    static func horizontal(
        _ alignment: HorizontalAlignment = .leading,
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle()
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .horizontal(alignment),
            cornerRadius: cornerRadius,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle
        )
    }
    
    static func vertical(
        _ alignment: VerticalAlignment = .top,
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle()
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .vertical(alignment),
            cornerRadius: cornerRadius,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle
        )
    }
    
    static func scrollable(
        _ axis: Axis = .horizontal,
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle()
    ) -> DefaultCompactSliderStyle {
        .init(
            type: axis == .horizontal ? .scrollableHorizontal : .scrollableVertical,
            cornerRadius: cornerRadius,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle
        )
    }
    
    static func grid(
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle()
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .grid,
            cornerRadius: cornerRadius,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle
        )
    }
    
    static func circularGrid(
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle()
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .circularGrid,
            cornerRadius: cornerRadius,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle
        )
    }
}
