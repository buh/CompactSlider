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
                alignment: .center,
                scaleViews: [
                    .linear(
                        count: 11,
                        lineLength: 20,
                        axis: configuration.type.isVertical ? .vertical : .horizontal
                    ),
                    .linear(
                        count: 51,
                        lineLength: 10,
                        axis: configuration.type.isVertical ? .vertical : .horizontal,
                        skip: .each(5)
                    )
                ]
            )
        }
    }
}
