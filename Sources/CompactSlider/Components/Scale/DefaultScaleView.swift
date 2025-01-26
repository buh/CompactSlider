// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct DefaultScaleView: View {
    let configuration: CompactSliderStyleConfiguration
    
    var body: some View {
        if configuration.type.isScrollable {
            ScaleZStackView(
                configuration: configuration,
                alignment: .center,
                shapeStyles: [
                    .linear(
                        axis: configuration.type.isVertical ? .vertical : .horizontal,
                        count: 11,
                        lineLength: 20
                    ),
                    .linear(
                        axis: configuration.type.isVertical ? .vertical : .horizontal,
                        count: 51,
                        lineLength: 10,
                        skip: .each(5)
                    )
                ]
            )
        }
    }
}
