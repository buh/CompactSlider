// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension View {
    public func horizontalGradientMask() -> some View {
        mask(
            LinearGradient(
                colors: [.clear, .white, .white, .white, .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
    
    public func verticalGradientMask() -> some View {
        mask(
            LinearGradient(
                colors: [.clear, .white, .white, .white, .clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Internal

extension View {
    func anyView() -> AnyView {
        AnyView(self)
    }
}
