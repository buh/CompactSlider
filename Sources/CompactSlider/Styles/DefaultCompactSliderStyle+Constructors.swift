// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public extension DefaultCompactSliderStyle {
    static func horizontal(
        _ alignment: HorizontalAlignment = .leading,
        handleStyle: HandleStyle = .rectangle(),
        scaleStyle: ScaleStyle? = ScaleStyle(),
        cornerRadius: CGFloat = Defaults.cornerRadius,
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .horizontal(alignment),
            handleStyle: handleStyle,
            scaleStyle: scaleStyle,
            cornerRadius: cornerRadius,
            padding: padding
        )
    }
    
    static func vertical(
        _ alignment: VerticalAlignment = .top,
        handleStyle: HandleStyle = .rectangle(),
        scaleStyle: ScaleStyle? = ScaleStyle(),
        cornerRadius: CGFloat = Defaults.cornerRadius,
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .vertical(alignment),
            handleStyle: handleStyle,
            scaleStyle: scaleStyle,
            cornerRadius: cornerRadius,
            padding: padding
        )
    }
    
    static func scrollable(
        _ axis: Axis = .horizontal,
        handleStyle: HandleStyle = .rectangle(),
        scaleStyle: ScaleStyle? = ScaleStyle(),
        cornerRadius: CGFloat = Defaults.cornerRadius,
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: axis == .horizontal ? .scrollableHorizontal : .scrollableVertical,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle,
            cornerRadius: cornerRadius,
            padding: padding
        )
    }
    
    static func grid(
        handleStyle: HandleStyle = .circle(),
        scaleStyle: ScaleStyle? = nil,
        cornerRadius: CGFloat = Defaults.gridCornerRadius,
        padding: EdgeInsets = .all(Defaults.gridCornerRadius / 2)
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .grid,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle,
            cornerRadius: cornerRadius,
            padding: padding
        )
    }
    
    static func circularGrid(
        handleStyle: HandleStyle = .circle(),
        scaleStyle: ScaleStyle? = ScaleStyle(),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .circularGrid,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle,
            cornerRadius: 0,
            padding: padding
        )
    }
}
