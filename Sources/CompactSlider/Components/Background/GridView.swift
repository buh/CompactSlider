// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A grid view. It renders a grid with a specified size and padding, using the `Grid` shape.
public struct GridView<GridShapeStyle: ShapeStyle>: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.handleStyle) var environmentHandleStyle
    var handleStyle: HandleStyle { environmentHandleStyle.byType(configuration.type) }
    
    let configuration: CompactSliderStyleConfiguration
    let padding: EdgeInsets
    let gridFill: GridShapeStyle?
    let gridSize: CGFloat?
    let inverted: Bool
    
    public init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        gridFill: GridShapeStyle,
        gridSize: CGFloat? = nil,
        inverted: Bool = true
    ) {
        self.configuration = configuration
        self.padding = padding
        self.gridFill = gridFill
        self.gridSize = gridSize
        self.inverted = inverted
    }
    
    public var body: some View {
        let gridSize: CGFloat = max(2, self.gridSize ?? (handleStyle.width / 3).pixelPerfect())
        let offset = (handleStyle.width - gridSize) / 2
        
        let padding = EdgeInsets(
            top: padding.top + offset,
            leading: padding.leading + offset,
            bottom: padding.bottom + offset,
            trailing: padding.trailing + offset
        )
        
        if let gridFill {
            Grid(
                countX: configuration.pointSteps.x,
                countY: configuration.pointSteps.y,
                size: gridSize,
                padding: padding,
                inverse: inverted
            )
            .fill(gridFill, style: .init(eoFill: inverted))
        } else {
            Grid(
                countX: configuration.pointSteps.x,
                countY: configuration.pointSteps.y,
                size: gridSize,
                padding: padding,
                inverse: inverted
            )
            .fillUltraThinMaterial(inverted: inverted)
        }
    }
}

extension GridView where GridShapeStyle == Color {
    public init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        gridSize: CGFloat? = nil,
        inverted: Bool = true
    ) {
        self.configuration = configuration
        self.padding = padding
        self.gridFill = nil
        self.gridSize = gridSize
        self.inverted = inverted
    }
}
