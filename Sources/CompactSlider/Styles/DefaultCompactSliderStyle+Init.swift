// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension DefaultCompactSliderStyle {
    /// Creates a horizontal compact slider style. By default the alignment is leading,
    /// clip shape style is rounded rectangle and padding is zero.
    ///
    /// - Parameters:
    ///  - alignment: a horizontal alignment.
    ///  - clipShapeStyle: a clip shape style.
    ///  - padding: an edge insets.
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
    
    /// Creates a vertical compact slider style. By default the alignment is bottom,
    /// clip shape style is rounded rectangle and padding is zero.
    ///
    /// - Parameters:
    /// - alignment: a vertical alignment.
    /// - clipShapeStyle: a clip shape style.
    /// - padding: an edge insets.
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
    
    /// Creates a scrollable compact slider style. By default the axis is horizontal,
    /// clip shape style is rectangle and padding is zero.
    ///
    /// - Parameters:
    /// - axis: a scrollable axis.
    /// - clipShapeStyle: a clip shape style.
    /// - padding: an edge insets.
    public static func scrollable(
        _ axis: Axis = .horizontal,
        clipShapeStyle: ClipShapeStyle = .rectangle,
        padding: EdgeInsets = .zero
    ) -> DefaultCompactSliderStyle {
        .init(
            type: axis == .horizontal ? .scrollableHorizontal : .scrollableVertical,
            clipShapeStyle: clipShapeStyle,
            padding: padding
        )
    }
    
    /// Creates a grid compact slider style. By default the clip shape style is rounded rectangle
    /// and padding is zero.
    ///
    /// - Parameters:
    /// - clipShapeStyle: a clip shape style.
    /// - padding: an edge insets.
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
    
    /// Creates a circular grid compact slider style. By default the padding is zero.
    ///
    /// - Parameters:
    /// - padding: an edge insets.
    public static func circularGrid(padding: EdgeInsets = .zero) -> DefaultCompactSliderStyle {
        .init(
            type: .circularGrid,
            clipShapeStyle: .none,
            padding: padding
        )
    }
}
