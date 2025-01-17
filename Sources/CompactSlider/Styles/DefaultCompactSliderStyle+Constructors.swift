// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension DefaultCompactSliderStyle {
    public static func horizontal(
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
    
    public static func vertical(
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
    
    public static func scrollable(
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
    
    public static func grid(
        handleStyle: HandleStyle = .circle(),
        cornerRadius: CGFloat = Defaults.gridCornerRadius,
        padding: EdgeInsets = Defaults.gridPadding
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .grid,
            handleStyle: handleStyle,
            cornerRadius: cornerRadius,
            padding: padding
        )
    }
    
    public static func circularGrid(
        handleStyle: HandleStyle = .circle(),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .circularGrid,
            handleStyle: handleStyle,
            cornerRadius: 0,
            padding: padding
        )
    }
}
