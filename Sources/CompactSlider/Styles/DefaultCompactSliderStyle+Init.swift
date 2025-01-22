// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension DefaultCompactSliderStyle {
    public static func horizontal(
        _ alignment: HorizontalAlignment = .leading,
        handleStyle: HandleStyle = .rectangle(),
        scaleStyle: ScaleStyle? = .atSide(),
        clipShapeType: ClipShapeType = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .horizontal(alignment),
            handleStyle: handleStyle,
            scaleStyle: scaleStyle,
            clipShapeStyle: clipShapeType,
            padding: padding
        )
    }
    
    public static func vertical(
        _ alignment: VerticalAlignment = .bottom,
        handleStyle: HandleStyle = .rectangle(),
        scaleStyle: ScaleStyle? = .centered(),
        clipShapeType: ClipShapeType = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .vertical(alignment),
            handleStyle: handleStyle,
            scaleStyle: scaleStyle,
            clipShapeStyle: clipShapeType,
            padding: padding
        )
    }
    
    public static func scrollable(
        _ axis: Axis = .horizontal,
        handleStyle: HandleStyle = .rectangle(),
        scaleStyle: ScaleStyle? = .atSide(),
        clipShapeType: ClipShapeType = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: axis == .horizontal ? .scrollableHorizontal : .scrollableVertical,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle,
            clipShapeStyle: clipShapeType,
            padding: padding
        )
    }
    
    public static func grid(
        handleStyle: HandleStyle = .circle(),
        clipShapeType: ClipShapeType = .roundedRectangle(cornerRadius: Defaults.gridCornerRadius),
        padding: EdgeInsets = Defaults.gridPadding
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .grid,
            handleStyle: handleStyle,
            clipShapeStyle: clipShapeType,
            padding: padding
        )
    }
    
    public static func circularGrid(
        handleStyle: HandleStyle = .circle(),
        scaleStyle: ScaleStyle? = nil,
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .circularGrid,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle,
            clipShapeStyle: .none,
            padding: padding
        )
    }
}
