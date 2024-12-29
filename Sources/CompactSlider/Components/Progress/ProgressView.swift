// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressView<Fill: ShapeStyle, FocusedFill: ShapeStyle>: View {
    let focusState: CompactSliderStyleConfiguration.FocusState
    let fillStyle: Fill
    let focusedFillStyle: FocusedFill
    
    var body: some View {
        Group {
            if focusState.isFocused {
                Rectangle().fill(focusedFillStyle)
            } else {
                Rectangle().fill(fillStyle)
            }
        }
    }
}
