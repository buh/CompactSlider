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
            
            scaleView(configuration, scaleStyle)
                .backgroundIf(configuration.options.contains(.moveBackgroundToScale))
                .offset(x: offset.x, y: offset.y)
                .allowsTightening(false)
        }
    }
}
