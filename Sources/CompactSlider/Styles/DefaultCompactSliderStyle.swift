// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
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
            if !configuration.progress.isMultipleValues && !configuration.type.isScrollable {
                CompactSliderStyleProgressView()
            }
            
            if let scaleStyle, configuration.isScaleVisible(scaleStyle: scaleStyle) {
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
        .background(CompactSliderStyleBackgroundView())
        .clipRoundedShapeIf(cornerRadius: cornerRadius)
        .environment(\.compactSliderStyleConfiguration, configuration)
        .environment(\.handleStyle, handleStyle)
        .environment(\.scaleStyle, scaleStyle)
    }
}

// MARK: - Constructors

public extension DefaultCompactSliderStyle {
    static func horizontal(
        _ alignment: HorizontalAlignment = .leading,
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle()
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .horizontal(alignment),
            cornerRadius: cornerRadius,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle
        )
    }
    
    static func vertical(
        _ alignment: VerticalAlignment = .top,
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle()
    ) -> DefaultCompactSliderStyle {
        .init(
            type: .vertical(alignment),
            cornerRadius: cornerRadius,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle
        )
    }
    
    static func scrollable(
        _ axis: Axis = .horizontal,
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle()
    ) -> DefaultCompactSliderStyle {
        .init(
            type: axis == .horizontal ? .scrollableHorizontal : .scrollableVertical,
            cornerRadius: cornerRadius,
            handleStyle: handleStyle,
            scaleStyle: scaleStyle
        )
    }
    // TODO: Scrollable
}

private extension View {
    @ViewBuilder
    func clipRoundedShapeIf(cornerRadius: CGFloat) -> some View {
        if cornerRadius > 0 {
            clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            self
        }
    }
}
