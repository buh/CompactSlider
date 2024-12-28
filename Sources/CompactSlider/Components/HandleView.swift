// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct HandleView: View {
    let style: HandleStyle
    let configuration: CompactSliderStyleConfiguration
    let indices: [Int]
    
    init(style: HandleStyle, configuration: CompactSliderStyleConfiguration) {
        self.style = style
        self.configuration = configuration
        
        indices = Array(stride(
            from: configuration.progresses.startIndex,
            to: configuration.progresses.endIndex,
            by: 1
        ))
    }
    
    public var body: some View {
        ForEach(indices, id: \.self) { index in
            let offset = configuration.offset(at: index, handleWidth: style.width)
            
            Group {
                if style.cornerRadius > 0 {
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .fill(Color.accentColor)
                } else {
                    Rectangle()
                        .fill(Color.accentColor)
                }
            }
            .frame(
                width: configuration.type.isHorizontal ? style.width : nil,
                height: configuration.type.isVertical ? style.width : nil
            )
            .offset(x: offset.x, y: offset.y)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}
