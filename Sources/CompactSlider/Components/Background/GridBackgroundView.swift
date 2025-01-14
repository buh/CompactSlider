// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct GridBackgroundView<GridShapeStyle: ShapeStyle>: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.handleStyle) var handleStyle
    
    let configuration: CompactSliderStyleConfiguration
    let padding: EdgeInsets
    let backgroundColor: Color?
    let handleColor: Color?
    let guidelineColor: Color?
    let normalizedBacklightRadius: CGFloat
    let gridFill: GridShapeStyle?
    let gridSize: CGFloat?
    let inverseGrid: Bool
    
    public init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        backgroundColor: Color? = Defaults.backgroundColor.opacity(0.1),
        handleColor: Color? = nil,
        guidelineColor: Color? = nil,
        normalizedBacklightRadius: CGFloat = 0.5,
        gridFill: GridShapeStyle,
        gridSize: CGFloat? = nil,
        inverseGrid: Bool = true
    ) {
        self.configuration = configuration
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.handleColor = handleColor
        self.guidelineColor = guidelineColor
        self.normalizedBacklightRadius = normalizedBacklightRadius.clamped()
        self.gridFill = gridFill
        self.gridSize = gridSize
        self.inverseGrid = inverseGrid
    }
    
    public var body: some View {
        ZStack {
            backgroundColor
            
            if normalizedBacklightRadius > 0, configuration.focusState.isFocused {
                backlightView()
            }
            
            guidelinesView(step: configuration.step)
            gridView()
        }
    }
    
    private var countX: Int { configuration.step?.pointSteps?.x ?? 11 }
    private var countY: Int { configuration.step?.pointSteps?.y ?? 11 }

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
            .blur(radius: min(configuration.size.width, configuration.size.height) / 8)
    }
    
    @ViewBuilder
    private func guidelinesView(step: CompactSliderStep?) -> some View {
        if let pointProgressStep = step?.pointProgressStep {
            Rectangle()
                .fill(guidelineColor ?? handleStyle.color.opacity(0.333))
                .offset(x: handleX.rounded(
                    toStep: pointProgressStep.x * (configuration.size.width - handleStyle.width)
                ))
                .frame(width: handleStyle.width)
            
            Rectangle()
                .fill(guidelineColor ?? handleStyle.color.opacity(0.333))
                .offset(y: handleY.rounded(
                    toStep: pointProgressStep.y * (configuration.size.height - handleStyle.width)
                ))
                .frame(height: handleStyle.width)
        }
    }
    
    @ViewBuilder
    private func gridView() -> some View {
        let gridSize: CGFloat = max(2, self.gridSize ?? (handleStyle.width / 3).roundedByPixel())
        let offset = (handleStyle.width - gridSize) / 2
        
        let padding = EdgeInsets(
            top: padding.top + offset,
            leading: padding.leading + offset,
            bottom: padding.bottom + offset,
            trailing: padding.trailing + offset
        )
        
        if let gridFill {
            Grid(
                countX: countX,
                countY: countY,
                size: gridSize,
                padding: padding,
                inverse: inverseGrid
            )
            .fill(gridFill, style: .init(eoFill: inverseGrid))
        } else if #available(macOS 12.0, iOS 15, *) {
            Grid(
                countX: countX,
                countY: countY,
                size: gridSize,
                padding: padding,
                inverse: inverseGrid
            )
            .fill(.ultraThinMaterial, style: .init(eoFill: inverseGrid))
        } else {
            Grid(
                countX: countX,
                countY: countY,
                size: gridSize,
                padding: padding,
                inverse: inverseGrid
            )
            .fill(Color(white: colorScheme == .dark ? 0.2 : 0.85), style: .init(eoFill: inverseGrid))
        }
    }
}

public extension GridBackgroundView where GridShapeStyle == Color {
    init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        backgroundColor: Color? = Defaults.backgroundColor.opacity(0.1),
        handleColor: Color? = nil,
        guidelineColor: Color? = nil,
        normalizedBacklightRadius: CGFloat = 0.5,
        gridSize: CGFloat? = nil,
        inverseGrid: Bool = true
    ) {
        self.configuration = configuration
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.handleColor = handleColor
        self.guidelineColor = guidelineColor
        self.normalizedBacklightRadius = normalizedBacklightRadius.clamped()
        self.gridFill = nil
        self.gridSize = gridSize
        self.inverseGrid = inverseGrid
    }
}

#Preview {
    GridBackgroundView(
        configuration: .init(
            type: .grid,
            size: .init(width: 300, height: 300),
            focusState: .none,
            progress: .init([0.5, 0.5]),
            step: nil,
            options: []
        ),
        padding: .all(Defaults.gridCornerRadius / 2)
    )
    #if os(macOS)
    .frame(width: 300, height: 300, alignment: .top)
    #endif
    .padding()
}
