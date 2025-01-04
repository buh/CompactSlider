// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ScaleContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    @Environment(\.scaleStyle) var scaleStyle
    let scaleView: (CompactSliderStyleConfiguration, ScaleStyle) -> V
    
    init(scaleView: @escaping (CompactSliderStyleConfiguration, ScaleStyle) -> V) {
        self.scaleView = scaleView
    }
    
    var body: some View {
        if let scaleStyle {
            let offset = configuration.scaleOffset()
            
            if configuration.type.isScrollable,
               configuration.options.contains(.loopValues),
               configuration.type.isHorizontal {
                HStack(spacing: 0) {
                    scaleView(configuration, scaleStyle)
                    scaleView(configuration, scaleStyle.skipedEdges(true))
                    scaleView(configuration, scaleStyle)
                }
                .offset(x: offset.x, y: offset.y)
                .frame(width: configuration.size.width * 3)
                .backgroundIf(configuration.options.contains(.moveBackgroundToScale))
                .frame(width: configuration.size.width)
                .allowsTightening(false)
            } else if configuration.type.isScrollable,
                      configuration.options.contains(.loopValues),
                      configuration.type.isVertical {
                VStack(spacing: 0) {
                    scaleView(configuration, scaleStyle)
                    scaleView(configuration, scaleStyle.skipedEdges(true))
                    scaleView(configuration, scaleStyle)
                }
                .offset(x: offset.x, y: offset.y)
                .frame(height: configuration.size.height * 3)
                .backgroundIf(configuration.options.contains(.moveBackgroundToScale))
                .frame(height: configuration.size.height)
                .allowsTightening(false)
            } else {
                scaleView(configuration, scaleStyle)
                    .offset(x: offset.x, y: offset.y)
                    .allowsTightening(false)
            }
        }
    }
}
