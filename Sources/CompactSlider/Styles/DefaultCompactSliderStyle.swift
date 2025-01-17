// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// The default slider style.
public struct DefaultCompactSliderStyle: CompactSliderStyle {
    public let type: CompactSliderType
    public let padding: EdgeInsets
    
    let handleStyle: HandleStyle
    let scaleStyle: ScaleStyle?
    let gaugeStyle: GaugeStyle?
    let cornerRadius: CGFloat
    
    public init(
        type: CompactSliderType = .horizontal(.leading),
        handleStyle: HandleStyle = .rectangle(),
        scaleStyle: ScaleStyle? = nil,
        gaugeStyle: GaugeStyle? = nil,
        cornerRadius: CGFloat = Defaults.cornerRadius,
        padding: EdgeInsets = .zero
    ) {
        self.type = type
        self.handleStyle = handleStyle
        self.scaleStyle = scaleStyle
        self.gaugeStyle = gaugeStyle
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .center) {
            if !configuration.progress.isMultipleValues,
               !configuration.progress.isGridValues,
               !configuration.progress.isCircularGridValues,
               !configuration.type.isScrollable {
                CompactSliderStyleProgressView()
            }
            
            if !configuration.progress.isGridValues,
               !configuration.progress.isCircularGridValues,
               let scaleStyle,
               configuration.isScaleVisible(scaleStyle: scaleStyle) {
                CompactSliderStyleScaleView()
            }
            
            if configuration.isHandleVisible(handleStyle: handleStyle) {
                if configuration.progress.isMultipleValues, configuration.progress.progresses.count == 0 {
                    Rectangle().fill(Color.clear)
                } else {
                    CompactSliderStyleHandleView()
                }
            }
        }
        .padding(padding)
        .backgroundIf(
            !configuration.options.contains(.moveBackgroundToScale)
            && !configuration.options.contains(.withoutBackground),
            padding: padding
        )
        .compositingGroup()
        .contentShape(Rectangle())
        .clipRoundedShapeIf(
            type: type,
            size: configuration.size,
            cornerRadius: cornerRadius
        )
        .environment(\.compactSliderStyleConfiguration, configuration)
        .environment(\.handleStyle, handleStyle)
        .environment(\.scaleStyle, scaleStyle)
    }
}

extension View {
    @ViewBuilder
    func backgroundIf(_ condition: Bool, padding: EdgeInsets = .zero) -> some View {
        if condition {
            background(CompactSliderStyleBackgroundView(padding: padding))
        } else {
            self
        }
    }
    
    @ViewBuilder
    func clipRoundedShapeIf(
        type: CompactSliderType,
        size: CGSize,
        cornerRadius: CGFloat
    ) -> some View {
        if type == .gauge {
            self
        } else if type == .circularGrid {
            clipShape(Circle())
        } else if cornerRadius > 0, size.minValue == 2 * cornerRadius {
            clipShape(Capsule())
        } else if cornerRadius > 0 {
            clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            clipShape(Rectangle())
        }
    }
}
