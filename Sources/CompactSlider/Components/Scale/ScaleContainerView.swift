// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ScaleContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    @Environment(\.scaleStyle) var scaleStyle
    let scaleView: (ScaleStyle, Axis, Int) -> V
    
    init(scaleView: @escaping (ScaleStyle, Axis, Int) -> V) {
        self.scaleView = scaleView
    }
    
    var body: some View {
        if let scaleStyle {
            let offset = configuration.scaleOffset()
            
            scaleView(scaleStyle, configuration.type.isHorizontal ? .horizontal : .vertical, configuration.steps)
                .offset(x: offset.x, y: offset.y)
                .allowsTightening(false)
        }
    }
}
