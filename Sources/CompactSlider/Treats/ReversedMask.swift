// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension View {
    /// Crops this view using the alpha channel of the given view.
    /// - Parameters:
    ///   - alignment: The alignment for mask in relation to this view.
    ///   - mask: The view whose alpha the rendering system applies to the specified view.
    public func reversedMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask(alignment: alignment) {
            ZStack {
                self.saturation(0).brightness(1)
                mask().saturation(0).brightness(-1)
            }
            .compositingGroup()
            .luminanceToAlpha()
        }
    }
}
