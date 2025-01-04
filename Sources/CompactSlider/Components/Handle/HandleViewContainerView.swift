// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct HandleViewContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    @Environment(\.handleStyle) var handleStyle
    let handleView: (CompactSliderStyleConfiguration, HandleStyle, Double, Int) -> V
    
    var indices: [Int] {
        Array(stride(
            from: configuration.progress.progresses.startIndex,
            to: configuration.progress.progresses.endIndex,
            by: 1
        ))
    }
    
    init(handleView: @escaping (CompactSliderStyleConfiguration, HandleStyle, Double, Int) -> V) {
        self.handleView = handleView
    }
    
    var body: some View {
        ForEach(indices, id: \.self) { index in
            let offset = configuration.handleOffset(at: index, handleWidth: handleStyle.width)
            
            handleView(configuration, handleStyle, configuration.progress(at: index), index)
                .frame(
                    width: configuration.type.isHorizontal ? handleStyle.width : nil,
                    height: configuration.type.isVertical ? handleStyle.width : nil
                )
                .offset(x: offset.x, y: offset.y)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .allowsHitTesting(false)
    }
}
