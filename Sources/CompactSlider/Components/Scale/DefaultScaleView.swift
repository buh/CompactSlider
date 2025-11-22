// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct DefaultScaleView: View {
    var alignment: Alignment = .center
    let configuration: CompactSliderStyleConfiguration
    
    var body: some View {
        if configuration.type.isScrollable {
            let axis: Axis = configuration.type.isVertical ? .vertical : .horizontal
            
            ScaleZStackView(
                configuration: configuration,
                alignment: alignment,
                shapeStyles: [
                    .linear(axis: axis, count: 11, lineLength: Defaults.scaleLineLength),
                    .linear(
                        axis: axis,
                        count: 51,
                        color: Defaults.secondaryScaleLineColor,
                        lineLength: Defaults.secondaryScaleLineLength,
                        skip: .each(5)
                    )
                ]
            )
        } else if let linearSteps = configuration.step?.linearSteps, linearSteps > 1 {
            ScaleZStackView(
                configuration: configuration,
                alignment: alignment,
                shapeStyles: [
                    .linear(
                        axis: configuration.type.isVertical ? .vertical : .horizontal,
                        count: linearSteps,
                        lineLength: Defaults.scaleLineLength,
                        skipFirst: 1,
                        skipLast: 1
                    )
                ]
            )
        }
    }
}
