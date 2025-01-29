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

/// A set of clip shape options.
public struct ClipShapeOptionSet: OptionSet {
    public let rawValue: Int
    
    /// Sets a clipping shape for the background.
    public static let background = ClipShapeOptionSet(rawValue: 1 << 0)
    /// Sets a clipping shape for the progress view.
    public static let progress = ClipShapeOptionSet(rawValue: 1 << 1)
    /// Sets a clipping shape for the scale view.
    public static let scale = ClipShapeOptionSet(rawValue: 1 << 2)
    /// Sets clipping shapes for all.
    public static let all = ClipShapeOptionSet(rawValue: 1 << 3)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension View {
    @ViewBuilder
    func clipShapeStyleIf(_ condition: Bool, style: ClipShapeStyle) -> some View {
        switch condition ? style : ClipShapeStyle.none {
        case .none: self
        case .circle: clipShape(Circle())
        case .capsule: clipShape(Capsule())
        case .roundedRectangle(let cornerRadius):
            clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        case .rectangle: clipShape(Rectangle())
        }
    }
    
    @ViewBuilder
    func contentShape(_ style: ClipShapeStyle) -> some View {
        switch style {
        case .circle:
            contentShape(Circle())
        case .capsule:
            contentShape(Capsule())
        case .roundedRectangle(let cornerRadius):
            contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        default:
            contentShape(Rectangle())
        }
    }
}
