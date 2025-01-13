// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct GridBackgroundView<GridFillStyle: ShapeStyle>: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.handleStyle) var handleStyle
    
    let configuration: CompactSliderStyleConfiguration
    let padding: EdgeInsets
    let backgroundColor: Color?
    let gridFill: GridFillStyle?
    let gridSize: CGFloat?
    
    public init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        backgroundColor: Color? = nil,
        gridFill: GridFillStyle,
        gridSize: CGFloat? = nil
    ) {
        self.configuration = configuration
        self.padding = padding
        self.backgroundColor = backgroundColor ?? Defaults.backgroundColor.opacity(0.1)
        self.gridFill = gridFill
        self.gridSize = gridSize
    }
    
    public var body: some View {
        ZStack {
            backgroundColor
            highlightView()
            guidelinesView(step: configuration.step)
            gridView()
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
    
    private func highlightView() -> some View {
        Circle()
            .fill(handleStyle.color.opacity(0.8))
            .offset(x: handleX, y: handleY)
            .frame(width: configuration.size.width / 2, height: configuration.size.height / 2)
            .blur(radius: min(configuration.size.width, configuration.size.height) / 7)
    }
    
    @ViewBuilder
    private func guidelinesView(step: CompactSliderStep?) -> some View {
        if let pointProgressStep = step?.pointProgressStep {
            Rectangle()
                .fill(handleStyle.color.opacity(0.333))
                .offset(x: handleX.rounded(
                    toStep: pointProgressStep.x * (configuration.size.width - handleStyle.width)
                ))
                .frame(width: handleStyle.width)
            
            Rectangle()
                .fill(handleStyle.color.opacity(0.333))
                .offset(y: handleY.rounded(
                    toStep: pointProgressStep.y * (configuration.size.height - handleStyle.width)
                ))
                .frame(height: handleStyle.width)
        }
    }
    
    @ViewBuilder
    private func gridView() -> some View {
        let gridSize = self.gridSize ?? handleStyle.width / 3
        let offset = (handleStyle.width - gridSize) / 2
        let padding = EdgeInsets(
            top: padding.top + offset,
            leading: padding.leading + offset,
            bottom: padding.bottom + offset,
            trailing: padding.trailing + offset
        )
        
        if let gridFill {
            Grid(
                countX: 11,
                countY: 11,
                size: gridSize,
                padding: padding,
                inverse: true
            )
            .fill(gridFill, style: .init(eoFill: true))
        } else if #available(macOS 12.0, iOS 15, *) {
            Grid(
                countX: 11,
                countY: 11,
                size: gridSize,
                padding: padding,
                inverse: true
            )
            .fill(.ultraThinMaterial, style: .init(eoFill: true))
        } else {
            Grid(
                countX: 11,
                countY: 11,
                size: gridSize,
                padding: padding,
                inverse: true
            )
            .fill(Color(white: colorScheme == .dark ? 0.2 : 0.85), style: .init(eoFill: true))
        }
    }
}

public extension GridBackgroundView where GridFillStyle == Color {
    init(
        configuration: CompactSliderStyleConfiguration,
        padding: EdgeInsets,
        backgroundColor: Color? = nil,
        gridSize: CGFloat? = nil
    ) {
        self.configuration = configuration
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.gridFill = nil
        self.gridSize = gridSize
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
