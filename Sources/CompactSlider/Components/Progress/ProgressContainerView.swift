// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressContainerView<P: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    let progressView: (Progress, CompactSliderStyleConfiguration.FocusState) -> P
    
    var alignment: Alignment {
        if configuration.type.isHorizontal {
            return .leading
        }
        
        return .top
    }
    
    init(@ViewBuilder progressView: @escaping (Progress, CompactSliderStyleConfiguration.FocusState) -> P) {
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
