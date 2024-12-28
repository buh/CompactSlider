// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// The default slider style.
public struct DefaultCompactSliderStyle: CompactSliderStyle {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let handleConfiguration: HandleConfiguration
    let scaleConfiguration: ScaleConfiguration?
    
    public init(
        handleWidth: CGFloat = 4,
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        handleConfiguration: HandleConfiguration = HandleConfiguration(),
        scaleConfiguration: ScaleConfiguration? = ScaleConfiguration()
    ) {
        self.backgroundColor = backgroundColor ?? .label.opacity(0.075)
        self.cornerRadius = cornerRadius ?? .cornerRadius
        self.handleConfiguration = handleConfiguration
        self.scaleConfiguration = scaleConfiguration
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            ProgressView(configuration: configuration)
            
            if let scaleConfiguration, isScaleVisible(configuration: configuration) {
                ScaleView(
                    direction: configuration.type.isHorizontal ? .horizontal : .vertical,
                    steps: configuration.steps,
                    configuration: scaleConfiguration
                )
            }
            
            if isHandleVisible(configuration: configuration) {
                RectangleHandleView(width: handleConfiguration.width, configuration: configuration)
            }
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private func isScaleVisible(configuration: Configuration) -> Bool {
        guard let scaleConfiguration else { return false }
        
        return scaleConfiguration.visibility != .hidden
            && (configuration.type.isHorizontal || configuration.type.isVertical)
            && (scaleConfiguration.visibility == .always || configuration.isFocused)
    }
    
    private func isHandleVisible(configuration: Configuration) -> Bool {
        guard handleConfiguration.visibility == .hovering else {
            return handleConfiguration.visibility == .always
        }
        
        if configuration.isFocused {
            return true
        }
        
        guard configuration.isSingularValue else {
            return false
        }
        
        if configuration.type.isHorizontal {
            if configuration.type.horizontalDirection == .center {
                return configuration.progress == 0.5
            }
            
            return configuration.progress == 0
        }
        
        if configuration.type.isVertical {
            if configuration.type.verticalDirection == .center {
                return configuration.progress == 0.5
            }
            
            return configuration.progress == 0
        }
        
        return false
    }
}

public extension CompactSliderStyle where Self == DefaultCompactSliderStyle {
    static var `default`: DefaultCompactSliderStyle { DefaultCompactSliderStyle() }
}
