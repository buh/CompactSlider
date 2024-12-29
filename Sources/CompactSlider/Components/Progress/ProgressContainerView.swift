// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    let progressView: (Progress, CompactSliderStyleConfiguration.FocusState) -> V
    
    var alignment: Alignment {
        if configuration.type.isHorizontal {
            return .leading
        }
        
        return .top
    }
    
    init(progressView: @escaping (Progress, CompactSliderStyleConfiguration.FocusState) -> V) {
        self.progressView = progressView
    }
    
    var body: some View {
        let size = configuration.progressSize()
        let offset = configuration.progressOffset()
        
        progressView(configuration.progress, configuration.focusState)
            .frame(width: size.width, height: size.height)
            .offset(x: offset.x, y: offset.y)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .allowsTightening(false)
    }
}
