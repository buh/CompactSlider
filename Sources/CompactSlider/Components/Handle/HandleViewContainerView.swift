// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct HandleViewContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    @Environment(\.handleStyle) var environmentHandleStyle
    var handleStyle: HandleStyle { environmentHandleStyle.byType(configuration.type) }
    let handleView: (CompactSliderStyleConfiguration, HandleStyle, Double, Int) -> V
    
    var indices: [Int] {
        Array(stride(
            from: configuration.progress.progresses.startIndex,
            to: configuration.progress.progresses.endIndex,
            by: 1
        ))
    }
    
    var width: CGFloat? {
        handleStyle.width > 0 ? handleStyle.width : nil
    }
    
    init(handleView: @escaping (CompactSliderStyleConfiguration, HandleStyle, Double, Int) -> V) {
        self.handleView = handleView
    }
    
    var body: some View {
        Group {
            if configuration.type == .grid || configuration.type == .circularGrid {
                let offset = configuration.handleOffset(at: 0, handleStyle: handleStyle)
                
                handleView(configuration, handleStyle, configuration.progress(at: 0), 0)
                    .frame(width: width, height: width)
                    .offset(x: offset.x, y: offset.y)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: configuration.type.isGrid || configuration.type.isCircularGrid
                            ? .topLeading
                            : configuration.type.isHorizontal ? .leading : .top
                    )
            } else {
                ForEach(indices, id: \.self) { index in
                    let offset = configuration.handleOffset(at: index, handleStyle: handleStyle)
                    
                    handleView(configuration, handleStyle, configuration.progress(at: index), index)
                        .frame(
                            width: configuration.type.isHorizontal || configuration.type == .grid ? width : nil,
                            height: configuration.type.isVertical || configuration.type == .grid ? width : nil
                        )
                        .offset(x: offset.x, y: offset.y)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: configuration.type.isHorizontal ? .leading : .top
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }
}
