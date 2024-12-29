// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct HandleView: View {
    let style: HandleStyle
    
    public init(style: HandleStyle) {
        self.style = style
    }
    
    public var body: some View {
        if style.cornerRadius > 0 {
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.color)
        } else {
            Rectangle()
                .fill(style.color)
        }
    }
}
