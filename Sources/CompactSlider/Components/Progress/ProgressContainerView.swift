// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    @Environment(\.handleStyle) var environmentHandleStyle
    var handleStyle: HandleStyle { environmentHandleStyle.byType(configuration.type) }
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
        let size = configuration.progressSize(handleStyle: handleStyle)
        let offset = configuration.progressOffset(handleStyle: handleStyle)
        
        progressView(configuration)
            .frame(width: size.width, height: size.height)
            .offset(x: offset.x, y: offset.y)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .allowsHitTesting(false)
    }
}
