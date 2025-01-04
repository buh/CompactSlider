// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension View {
    func anyView() -> AnyView {
        AnyView(self)
    }
}

public extension View {
    func horizontalGradientMask() -> some View {
        mask(
            LinearGradient(
                colors: [.clear, .white, .white, .white, .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
    
    func verticalGradientMask() -> some View {
        mask(
            LinearGradient(
                colors: [.clear, .white, .white, .white, .clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
