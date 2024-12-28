// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// The default slider style.
public struct DefaultCompactSliderStyle: CompactSliderStyle {
    let handleWidth: CGFloat
    let backgroundColor: Color
    let cornerRadius: CGFloat
    
    public init(handleWidth: CGFloat = 4, backgroundColor: Color? = nil, cornerRadius: CGFloat? = nil) {
        self.handleWidth = handleWidth
        self.backgroundColor = backgroundColor ?? .label.opacity(0.075)
        self.cornerRadius = cornerRadius ?? .cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            ProgressView(configuration: configuration)
            
            if configuration.type.isHorizontal || configuration.type.isVertical {
                ScaleView(
                    alignment: configuration.type.isHorizontal ? .horizontal : .vertical,
                    steps: configuration.steps
                )
            }
            
            RectangleHandleView(width: handleWidth, configuration: configuration)
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

public extension CompactSliderStyle where Self == DefaultCompactSliderStyle {
    static var `default`: DefaultCompactSliderStyle { DefaultCompactSliderStyle() }
}
