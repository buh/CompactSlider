// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension View {
    /// A linear gradient mask.
    @ViewBuilder
    public func gradientMask(
        axis: Axis,
        _ maskColors: [Color] = [.clear, .white, .white, .white, .clear]
    ) -> some View {
        if axis == .horizontal {
            horizontalGradientMask(maskColors)
        } else {
            verticalGradientMask(maskColors)
        }
    }
    
    /// A linear horizontal gradient mask.
    public func horizontalGradientMask(
        _ maskColors: [Color] = [.clear, .white, .white, .white, .clear]
    ) -> some View {
        mask(LinearGradient(colors: maskColors, startPoint: .leading, endPoint: .trailing))
    }
    
    /// A linear vertical gradient mask.
    public func verticalGradientMask(
        _ maskColors: [Color] = [.clear, .white, .white, .white, .clear]
    ) -> some View {
        mask(LinearGradient(colors: maskColors, startPoint: .top, endPoint: .bottom))
    }
}
