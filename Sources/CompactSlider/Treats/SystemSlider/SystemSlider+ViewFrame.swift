// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension View {
    /// Sets the size of the "system" slider.
    public func compactSliderSystemFrame(for type: Axis) -> some View {
        compactSliderSystemFrame(for: type == .horizontal ? .scrollableHorizontal : .scrollableVertical)
    }
    
    func compactSliderSystemFrame(for type: CompactSliderType) -> some View {
        #if os(macOS)
        frame(
            width: type.isVertical ? 20 : nil,
            height: type.isHorizontal ? 20 : nil
        )
        #elseif os(visionOS)
        frame(
            width: type.isVertical ? 32 : nil,
            height: type.isHorizontal ? 32 : nil
        )
        #else
        frame(
            width: type.isVertical ? 27 : nil,
            height: type.isHorizontal ? 27 : nil
        )
        #endif
    }
}
