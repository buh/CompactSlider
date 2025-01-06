// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// The default slider style.
public struct DefaultCompactSliderStyle: CompactSliderStyle {
    public let type: CompactSliderType
    let cornerRadius: CGFloat
    let handleStyle: HandleStyle
    let scaleStyle: ScaleStyle?
    
    public init(
        type: CompactSliderType = .horizontal(.leading),
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle()
    ) {
        self.type = type
        self.cornerRadius = cornerRadius
        self.handleStyle = handleStyle
        self.scaleStyle = scaleStyle
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .center) {
            if !configuration.progress.isMultipleValues,
               !configuration.progress.isGridValues,
               !configuration.type.isScrollable {
                CompactSliderStyleProgressView()
            }
            
            if !configuration.progress.isGridValues,
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
        .backgroundIf(
            !configuration.options.contains(.moveBackgroundToScale)
            && !configuration.options.contains(.withoutBackground)
        )
        .compositingGroup()
        .contentShape(Rectangle())
        .clipRoundedShapeIf(cornerRadius: cornerRadius)
        .environment(\.compactSliderStyleConfiguration, configuration)
        .environment(\.handleStyle, handleStyle)
        .environment(\.scaleStyle, scaleStyle)
    }
}

private extension View {
    @ViewBuilder
    func clipRoundedShapeIf(cornerRadius: CGFloat) -> some View {
        if cornerRadius > 0 {
            clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            clipShape(Rectangle())
        }
    }
}
