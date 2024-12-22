// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct RectangleHandleView: View {
    let width: CGFloat
    let configuration: CompactSliderStyleConfiguration
    let indices: [Int]
    
    init(width: CGFloat, configuration: CompactSliderStyleConfiguration) {
        self.width = width
        self.configuration = configuration
        
        indices = Array(stride(
            from: configuration.progresses.startIndex,
            to: configuration.progresses.endIndex,
            by: 1
        ))
    }
    
    public var body: some View {
        ForEach(indices, id: \.self) { index in
            let offset = configuration.offset(at: index, handleWidth: width)
            Rectangle()
                .fill(configuration.isFocused ? Color.accentColor : Color.gray)
                .frame(
                    width: configuration.type.isHorizontal ? width : nil,
                    height: configuration.type.isVertical ? width : nil
                )
                .offset(x: offset.x, y: offset.y)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}
