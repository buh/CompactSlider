// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    let progressView: (CompactSliderStyleConfiguration) -> V
    
    var alignment: Alignment {
        if configuration.type.isHorizontal {
            return .leading
        }
        
        return .top
    }
    
    init(progressView: @escaping (CompactSliderStyleConfiguration) -> V) {
        self.progressView = progressView
    }
    
    var body: some View {
        let size = configuration.progressSize()
        let offset = configuration.progressOffset()
        
        progressView(configuration)
            .frame(width: size.width, height: size.height)
            .offset(x: offset.x, y: offset.y)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .allowsTightening(false)
    }
}
