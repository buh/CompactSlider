// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressView<S1: ShapeStyle, S2: ShapeStyle>: View {
    let configuration: CompactSliderStyleConfiguration
    let fillStyle: S2
    let focusedFillStyle: S1
    
    var body: some View {
        let size = configuration.progressSize()
        let offset = configuration.progressOffset()
        
        Group {
            if configuration.isFocused {
                Rectangle().fill(focusedFillStyle)
            } else {
                Rectangle().fill(fillStyle)
            }
        }
        .frame(width: size.width, height: size.height)
        .offset(x: offset.x, y: offset.y)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .allowsTightening(false)
    }
}
