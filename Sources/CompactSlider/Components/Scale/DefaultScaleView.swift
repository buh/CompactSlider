// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct DefaultScaleView: View {
    let configuration: CompactSliderStyleConfiguration
    let style: ScaleStyle
    
    public init(
        configuration: CompactSliderStyleConfiguration,
        style: ScaleStyle
    ) {
        self.configuration = configuration
        self.style = style
    }
    
    public var body: some View {
        if configuration.type.isCircularGrid {
            circularScaleView()
        } else {
            linearScaleView()
        }
    }
    
    private func linearScaleView() -> some View {
        ScaleView(
            style: style,
            alignment: configuration.type.isHorizontal ? .horizontal : .vertical,
            startFromCenter: configuration.type.isCenter,
            steps: configuration.step?.linearSteps ?? 0
        )
    }
    
    private func circularScaleView() -> some View {
        ZStack {
            Circle()
                .stroke(style.line.color, lineWidth: style.line.thickness)
                .padding(configuration.size.minValue / 3)
            
            Circle()
                .stroke(style.line.color, lineWidth: style.line.thickness)
                .padding(configuration.size.minValue / 6)
            
            Rectangle()
                .fill(style.line.color)
                .frame(width: style.line.thickness)
            
            Rectangle()
                .fill(style.line.color)
                .frame(height: style.line.thickness)
        }
    }
}
