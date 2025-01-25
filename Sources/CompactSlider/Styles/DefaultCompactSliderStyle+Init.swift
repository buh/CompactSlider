// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension DefaultCompactSliderStyle {
    public static func horizontal(
        _ alignment: HorizontalAlignment = .leading,
        scaleStyle: ScaleStyle? = .atSide(),
        clipShapeType: ClipShapeType = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .horizontal(alignment),
            scaleStyle: scaleStyle,
            clipShapeStyle: clipShapeType,
            padding: padding
        )
    }
    
    public static func vertical(
        _ alignment: VerticalAlignment = .bottom,
        scaleStyle: ScaleStyle? = .centered(),
        clipShapeType: ClipShapeType = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .vertical(alignment),
            scaleStyle: scaleStyle,
            clipShapeStyle: clipShapeType,
            padding: padding
        )
    }
    
    public static func scrollable(
        _ axis: Axis = .horizontal,
        scaleStyle: ScaleStyle? = .atSide(),
        clipShapeType: ClipShapeType = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: axis == .horizontal ? .scrollableHorizontal : .scrollableVertical,
            scaleStyle: scaleStyle,
            clipShapeStyle: clipShapeType,
            padding: padding
        )
    }
    
    public static func grid(
        clipShapeType: ClipShapeType = .roundedRectangle(cornerRadius: Defaults.gridCornerRadius),
        padding: EdgeInsets = Defaults.gridPadding
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .grid,
            clipShapeStyle: clipShapeType,
            padding: padding
        )
    }
    
    public static func circularGrid(
        scaleStyle: ScaleStyle? = nil,
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .circularGrid,
            scaleStyle: scaleStyle,
            clipShapeStyle: .none,
            padding: padding
        )
    }
}
