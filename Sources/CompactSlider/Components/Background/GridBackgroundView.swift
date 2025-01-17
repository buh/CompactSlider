// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct GridBackgroundView<
        BackgroundShapeStyle: ShapeStyle,
        GridShapeStyle: ShapeStyle
    >: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.handleStyle) var handleStyle
    
    let configuration: CompactSliderStyleConfiguration
    let padding: EdgeInsets
    let backgroundShapeStyle: BackgroundShapeStyle?
    let handleColor: Color?
    let guidelineColor: Color?
    let normalizedBacklightRadius: CGFloat
    let gridSize: CGFloat?
    let gridFill: GridShapeStyle?
    let invertedGrid: Bool
    
    public init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        backgroundFill: BackgroundShapeStyle,
        handleColor: Color? = nil,
        guidelineColor: Color? = nil,
        normalizedBacklightRadius: CGFloat = 0.5,
        gridSize: CGFloat? = nil,
        invertedGrid: Bool = true,
        gridFill: GridShapeStyle
    ) {
        self.configuration = configuration
        self.padding = padding
        self.backgroundShapeStyle = backgroundFill
        self.handleColor = handleColor
        self.guidelineColor = guidelineColor
        self.normalizedBacklightRadius = normalizedBacklightRadius.clamped()
        self.gridSize = gridSize
        self.invertedGrid = invertedGrid
        self.gridFill = gridFill
    }
    
    public var body: some View {
        ZStack {
            ZStack {
                if let backgroundShapeStyle {
                    Rectangle()
                        .fill(backgroundShapeStyle)
                }
                
                if normalizedBacklightRadius > 0, configuration.focusState.isFocused {
                    backlightView()
                }
                
                if invertedGrid {
                    guidelinesView(step: configuration.step)
                }
                
                backgroundGridView()
            }
            .compositingGroup()
            
            if !invertedGrid {
                guidelinesView(step: configuration.step)
                    .blendMode(.destinationOut)
            }
        }
    }
    
    private var handleX: CGFloat {
        configuration.handleOffset(at: 0, handleWidth: handleStyle.width).x
            - configuration.size.width / 2 + handleStyle.width / 2
    }
    
    private var handleY: CGFloat {
        configuration.handleOffset(at: 0, handleWidth: handleStyle.width).y
            - configuration.size.height / 2 + handleStyle.width / 2
    }
    
    private func backlightView() -> some View {
        Circle()
            .fill((handleColor ?? handleStyle.color).opacity(0.5))
            .offset(x: handleX, y: handleY)
            .frame(
                width: configuration.size.width * normalizedBacklightRadius,
                height: configuration.size.height * normalizedBacklightRadius
            )
            .blur(radius: configuration.size.minValue / 8)
    }
    
    @ViewBuilder
    private func guidelinesView(step: CompactSliderStep?) -> some View {
        if let pointProgressStep = step?.pointProgressStep {
            Rectangle()
                .fill(guidelineColor ?? handleStyle.color.opacity(0.333))
                .offset(x: handleX.rounded(
                    step: pointProgressStep.x * (configuration.size.width - handleStyle.width)
                ))
                .frame(width: handleStyle.width)
            
            Rectangle()
                .fill(guidelineColor ?? handleStyle.color.opacity(0.333))
                .offset(y: handleY.rounded(
                    step: pointProgressStep.y * (configuration.size.height - handleStyle.width)
                ))
                .frame(height: handleStyle.width)
        }
    }
    
    @ViewBuilder
    private func backgroundGridView() -> some View {
        if let gridFill {
            GridView<GridShapeStyle>(
                configuration: configuration,
                padding: padding,
                gridFill: gridFill,
                gridSize: gridSize,
                inverted: invertedGrid
            )
        } else if gridFill == nil {
            GridView(
                configuration: configuration,
                padding: padding,
                gridSize: gridSize,
                inverted: invertedGrid
            )
        }
    }
}

extension GridBackgroundView where BackgroundShapeStyle == Color, GridShapeStyle == Color {
    public init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        backgroundColor: Color? = Defaults.backgroundColor.opacity(0.1),
        handleColor: Color? = nil,
        guidelineColor: Color? = nil,
        normalizedBacklightRadius: CGFloat = 0.5,
        gridSize: CGFloat? = nil,
        invertedGrid: Bool = true
    ) {
        self.configuration = configuration
        self.padding = padding
        self.backgroundShapeStyle = backgroundColor
        self.handleColor = handleColor
        self.guidelineColor = guidelineColor
        self.normalizedBacklightRadius = normalizedBacklightRadius.clamped()
        self.gridSize = gridSize
        self.invertedGrid = invertedGrid
        self.gridFill = nil
    }
}

extension GridBackgroundView where GridShapeStyle == Color {
    public init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        backgroundFill: BackgroundShapeStyle,
        handleColor: Color? = nil,
        guidelineColor: Color? = nil,
        normalizedBacklightRadius: CGFloat = 0.5,
        gridSize: CGFloat? = nil,
        invertedGrid: Bool = true
    ) {
        self.configuration = configuration
        self.padding = padding
        self.backgroundShapeStyle = backgroundFill
        self.handleColor = handleColor
        self.guidelineColor = guidelineColor
        self.normalizedBacklightRadius = normalizedBacklightRadius.clamped()
        self.gridSize = gridSize
        self.invertedGrid = invertedGrid
        self.gridFill = nil
    }
}

extension GridBackgroundView where BackgroundShapeStyle == Color {
    public init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        backgroundColor: Color? = nil,
        handleColor: Color? = nil,
        guidelineColor: Color? = nil,
        normalizedBacklightRadius: CGFloat = 0.5,
        gridSize: CGFloat? = nil,
        invertedGrid: Bool = true,
        gridFill: GridShapeStyle
    ) {
        self.configuration = configuration
        self.padding = padding
        self.backgroundShapeStyle = backgroundColor
        self.handleColor = handleColor
        self.guidelineColor = guidelineColor
        self.normalizedBacklightRadius = normalizedBacklightRadius.clamped()
        self.gridSize = gridSize
        self.invertedGrid = invertedGrid
        self.gridFill = gridFill
    }
}
