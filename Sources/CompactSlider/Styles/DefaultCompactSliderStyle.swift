// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// The default slider style.
public struct DefaultCompactSliderStyle<Background: View>: CompactSliderStyle {
    public let type: CompactSliderType
    let cornerRadius: CGFloat
    let handleStyle: HandleStyle
    let scaleStyle: ScaleStyle?
    let background: (_ configuration: Configuration) -> Background

    public init(
        type: CompactSliderType = .horizontal(.leading),
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleConfiguration: HandleStyle = HandleStyle(),
        scaleConfiguration: ScaleStyle? = ScaleStyle(),
        background: @escaping (_ configuration: Configuration) -> Background
    ) {
        self.type = type
        self.background = background
        self.cornerRadius = cornerRadius
        self.handleStyle = handleConfiguration
        self.scaleStyle = scaleConfiguration
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .center) {
            CompactSliderStyleProgressView()
            
            if let scaleStyle, isScaleVisible(configuration: configuration) {
                ScaleView(
                    alignment: configuration.type.isHorizontal ? .horizontal : .vertical,
                    steps: configuration.steps,
                    configuration: scaleStyle
                )
            }
            
            if configuration.isHandleVisible(handleStyle: handleStyle) {
                CompactSliderStyleHandleView()
            }
        }
        .background(background(configuration))
        .clipRoundedShapeIf(cornerRadius: cornerRadius)
        .environment(\.compactSliderStyleConfiguration, configuration)
        .environment(\.handleStyle, handleStyle)
    }
    
    private func isScaleVisible(configuration: Configuration) -> Bool {
        guard let scaleStyle else { return false }
        
        return scaleStyle.visibility != .hidden
            && (configuration.type.isHorizontal || configuration.type.isVertical)
            && (scaleStyle.visibility == .always || configuration.focusState.isFocused)
    }
    
}

public extension DefaultCompactSliderStyle where Background == Color {
    init(
        type: CompactSliderType = .horizontal(.leading),
        cornerRadius: CGFloat = Defaults.cornerRadius,
        handleStyle: HandleStyle = HandleStyle(),
        scaleStyle: ScaleStyle? = ScaleStyle(),
        backgroundColor: @escaping (_ configuration: Configuration) -> Color = { _ in
            Defaults.label.opacity(Defaults.backgroundOpacity)
        }
    ) {
        self.type = type
        self.cornerRadius = cornerRadius
        self.handleStyle = handleStyle
        self.scaleStyle = scaleStyle
        self.background = { backgroundColor($0) }
    }
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

public extension CompactSliderStyle where Self == DefaultCompactSliderStyle<Color> {
    static var `default`: DefaultCompactSliderStyle<Color> { DefaultCompactSliderStyle() }
}
