// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    @Environment(\.compactSliderAnimations) var animations
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
            .animateProgress(animations[.progressDidChange], progress: configuration.progress)
    }
}

private extension View {
    @ViewBuilder
    func animateProgress(_ progressAnimation: Animation?, progress: Progress) -> some View {
        if let progressAnimation {
            animation(progressAnimation, value: progress.progresses)
        } else {
            self
        }
    }
}
