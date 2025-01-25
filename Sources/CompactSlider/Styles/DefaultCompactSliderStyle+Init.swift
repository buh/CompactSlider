// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension DefaultCompactSliderStyle {
    public static func horizontal(
        _ alignment: HorizontalAlignment = .leading,
        clipShapeStyle: ClipShapeStyle = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .horizontal(alignment),
            clipShapeStyle: clipShapeStyle,
            padding: padding
        )
    }
    
    public static func vertical(
        _ alignment: VerticalAlignment = .bottom,
        clipShapeStyle: ClipShapeStyle = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .vertical(alignment),
            clipShapeStyle: clipShapeStyle,
            padding: padding
        )
    }
    
    public static func scrollable(
        _ axis: Axis = .horizontal,
        clipShapeStyle: ClipShapeStyle = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: axis == .horizontal ? .scrollableHorizontal : .scrollableVertical,
            clipShapeStyle: clipShapeStyle,
            padding: padding
        )
    }
    
    public static func grid(
        clipShapeStyle: ClipShapeStyle = .roundedRectangle(cornerRadius: Defaults.gridCornerRadius),
        padding: EdgeInsets = Defaults.gridPadding
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .grid,
            clipShapeStyle: clipShapeStyle,
            padding: padding
        )
    }
    
    public static func circularGrid(padding: EdgeInsets = .zero) -> DefaultCompactSliderStyle {
        .init(
            type: .circularGrid,
            clipShapeStyle: .none,
            padding: padding
        )
    }
}
