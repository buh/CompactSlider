// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A clip shape style for a slider.
public enum ClipShapeStyle {
    /// No clip shape.
    case none
    /// A circle clip shape.
    case circle
    /// A capsule clip shape.
    case capsule
    /// A rounded rectangle clip shape with a corner radius.
    case roundedRectangle(cornerRadius: CGFloat)
    /// A rectangle clip shape.
    case rectangle
}

extension View {
    @ViewBuilder
    func clipShapeStyle(_ style: ClipShapeStyle) -> some View {
        switch style {
        case .none: self
        case .circle: clipShape(Circle())
        case .capsule: clipShape(Capsule())
        case .roundedRectangle(let cornerRadius):
            clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        case .rectangle: clipShape(Rectangle())
        }
    }
}
