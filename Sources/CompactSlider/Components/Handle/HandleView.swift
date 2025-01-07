// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct HandleView: View {
    let style: HandleStyle
    
    public init(style: HandleStyle) {
        self.style = style
    }
    
    public var body: some View {
        switch style.type {
        case .rectangle:
            Rectangle()
                .fill(style.color)
        case .roundedRectangle:
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.color)
        case .circle:
            if style.lineWidth > 0 {
                Circle()
                    .stroke(style.color, lineWidth: style.lineWidth)
            } else {
                Circle()
                    .fill(style.color)
            }
        }
    }
}
