// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public enum ClipShapeType {
    case none
    case circle
    case capsule
    case roundedRectangle(cornerRadius: CGFloat)
    case rectangle
}

extension View {
    @ViewBuilder
    func clipShapeStyle(_ style: ClipShapeType) -> some View {
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
