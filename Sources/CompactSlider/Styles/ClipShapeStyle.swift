// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A clip shape style. It can be used for clipping the background, progress view, and scale view or all of them.
public struct ClipShapeStyle {
    public let shape: ClipShapeStyle.Shape?
    public let options: ClipShapeOptionSet
    
    init(shape: ClipShapeStyle.Shape?, options: ClipShapeOptionSet = .all) {
        self.shape = shape
        self.options = options
    }
}

extension ClipShapeStyle {
    /// A clip shape.
    public enum Shape {
        /// A circle clip shape.
        case circle
        /// A capsule clip shape.
        case capsule
        /// A rounded rectangle clip shape with a corner radius.
        case roundedRectangle(cornerRadius: CGFloat)
        /// A rectangle clip shape.
        case rectangle
    }
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

extension ClipShapeStyle {
    /// A clip shape style with a circle shape.
    public static func circle(options: ClipShapeOptionSet = .all) -> ClipShapeStyle {
        ClipShapeStyle(shape: .circle, options: options)
    }
    
    /// A clip shape style with a capsule shape.
    public static func capsule(options: ClipShapeOptionSet = .all) -> ClipShapeStyle {
        ClipShapeStyle(shape: .capsule, options: options)
    }
    
    /// A clip shape style with a rectangle.
    public static func rectangle(options: ClipShapeOptionSet = .all) -> ClipShapeStyle {
        ClipShapeStyle(shape: .rectangle, options: options)
    }
    
    /// A clip shape style with a rounded rectangle shape.
    public static func roundedRectangle(cornerRadius: CGFloat, options: ClipShapeOptionSet = .all) -> ClipShapeStyle {
        ClipShapeStyle(shape: .roundedRectangle(cornerRadius: cornerRadius), options: options)
    }
    
    /// A clip shape style with no shape.
    public static let none = ClipShapeStyle(shape: nil)
    
    /// A default clip shape style for the given type.
    public static func `default`(for type: CompactSliderType) -> ClipShapeStyle {
        if type.isGrid {
            return ClipShapeStyle(shape: .roundedRectangle(cornerRadius: Defaults.gridCornerRadius))
        }
        
        if type.isCircularGrid {
            return ClipShapeStyle(shape: .circle)
        }
        
        return ClipShapeStyle(shape: .roundedRectangle(cornerRadius: Defaults.cornerRadius))
    }
}

// MARK: - View

extension View {
    @ViewBuilder
    func clipShapeStyleIf(_ condition: Bool, shape: ClipShapeStyle.Shape?) -> some View {
        if condition, let shape {
            switch shape {
            case .circle:
                clipShape(Circle())
            case .capsule:
                clipShape(Capsule())
            case .roundedRectangle(let cornerRadius):
                clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            case .rectangle:
                clipShape(Rectangle())
            }
        } else {
            self
        }
    }
    
    @ViewBuilder
    func contentShape(_ clipShape: ClipShapeStyle.Shape?) -> some View {
        if let shape = clipShape {
            switch shape {
            case .circle:
                contentShape(Circle())
            case .capsule:
                contentShape(Capsule())
            case .roundedRectangle(let cornerRadius):
                contentShape(RoundedRectangle(cornerRadius: cornerRadius))
            default:
                contentShape(Rectangle())
            }
        } else {
            self
        }
    }
}
