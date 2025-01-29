// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// An alignment position along the horizontal axis.
public enum HorizontalAlignment {
    case leading, center, trailing
}

/// An alignment position along the vertical axis.
public enum VerticalAlignment {
    case top, center, bottom
}

/// A slider type in which the slider will indicate the selected value.
/// It can be horizontal, vertical, scrollable, grid or circular grid.
/// The scrollable type can be horizontal or vertical.
public enum CompactSliderType: Equatable {
    case horizontal(HorizontalAlignment)
    case vertical(VerticalAlignment)
    case scrollableHorizontal
    case scrollableVertical
    case grid
    case circularGrid
    
    /// Returns true if the slider type is linear (horizontal or vertical). The scrollable type is linear too.
    public var isLinear: Bool { isHorizontal || isVertical }
    
    /// Returns true if the slider type is horizontal. The scrollable type could be horizontal as well.
    public var isHorizontal: Bool {
        switch self {
        case .horizontal, .scrollableHorizontal: return true
        default: return false
        }
    }
    
    /// Returns true if the slider type is vertical. The scrollable type could be vertical as well.
    public var isVertical: Bool {
        switch self {
        case .vertical, .scrollableVertical: return true
        default: return false
        }
    }
    
    /// Returns true if the slider type is horizontal or vertical and the alignment is center.
    public var isCenter: Bool {
        switch self {
        case .horizontal(let alignment): return alignment == .center
        case .vertical(let alignment): return alignment == .center
        default: return false
        }
    }
    
    /// Returns the horizontal alignment if the slider type is horizontal.
    public var horizontalAlignment: HorizontalAlignment? {
        if case .horizontal(let alignment) = self {
            return alignment
        }
        
        return nil
    }
    
    /// Returns the vertical alignment if the slider type is vertical.
    public var verticalAlignment: VerticalAlignment? {
        if case .vertical(let alignment) = self {
            return alignment
        }
        
        return nil
    }
    
    /// Returns true if the slider type is scrollable (horizontal or vertical).
    public var isScrollable: Bool {
        switch self {
        case .scrollableHorizontal, .scrollableVertical: return true
        default: return false
        }
    }
    
    /// Returns true if the slider type is grid.
    public var isGrid: Bool {
        switch self {
        case .grid: return true
        default: return false
        }
    }
    
    /// Returns true if the slider type is circular grid.
    public var isCircularGrid: Bool {
        switch self {
        case .circularGrid: return true
        default: return false
        }
    }
    
    var normalizedRangeValuesType: CompactSliderType {
        if case .horizontal = self {
            return .horizontal(.leading)
        }
        
        if case .vertical = self {
            return .vertical(.top)
        }
        
        return self
    }
}
