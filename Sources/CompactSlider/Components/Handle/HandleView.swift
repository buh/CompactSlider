// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct HandleView: View {
    let style: HandleStyle
    let progress: Double
    let index: Int
    
    public init(style: HandleStyle, progress: Double, index: Int) {
        self.style = style
        self.progress = progress
        self.index = index
    }
    
    public var body: some View {
        if style.cornerRadius > 0 {
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(Color.accentColor)
        } else {
            Rectangle()
                .fill(Color.accentColor)
        }
    }
}
