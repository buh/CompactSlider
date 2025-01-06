// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CircleHandleView: View {
    let style: HandleStyle
    
    public init(style: HandleStyle) {
        self.style = style
    }
    
    public var body: some View {
        Circle()
            .stroke(style.color, lineWidth: style.lineWidth)
    }
}
