// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    @Environment(\.handleStyle) var handleStyle
    let progressView: (CompactSliderStyleConfiguration) -> V
    
    var alignment: Alignment {
        if configuration.type.isHorizontal {
            return .leading
        }
        
        return .top
    }
    
    var padding: CGFloat {
        switch handleStyle.visibility {
        case .always: handleStyle.width
        case .hidden: 0
        case .hoveringOrDragging:
            configuration.focusState.isFocused ? handleStyle.width : 0
        }
    }
    
    init(progressView: @escaping (CompactSliderStyleConfiguration) -> V) {
        self.progressView = progressView
    }
    
    var body: some View {
        let size = configuration.progressSize(handleWidth: padding)
        let offset = configuration.progressOffset(handleWidth: padding)
        
        progressView(configuration)
            .frame(width: size.width, height: size.height)
            .offset(x: offset.x, y: offset.y)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .allowsTightening(false)
    }
}
