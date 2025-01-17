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
public enum CompactSliderType: Equatable {
    case horizontal(HorizontalAlignment)
    case vertical(VerticalAlignment)
    case scrollableHorizontal
    case scrollableVertical
    case gauge
    case grid
    case circularGrid
    
    public var isLinear: Bool { isHorizontal || isVertical }
    
    public var isHorizontal: Bool {
        switch self {
        case .horizontal, .scrollableHorizontal: return true
        default: return false
        }
    }
    
    public var isVertical: Bool {
        switch self {
        case .vertical, .scrollableVertical: return true
        default: return false
        }
    }
    
    public var isCenter: Bool {
        switch self {
        case .horizontal(let alignment): return alignment == .center
        case .vertical(let alignment): return alignment == .center
        default: return false
        }
    }
    
    public var horizontalAlignment: HorizontalAlignment? {
        if case .horizontal(let alignment) = self {
            return alignment
        }
        
        return nil
    }
    
    public var verticalAlignment: VerticalAlignment? {
        if case .vertical(let alignment) = self {
            return alignment
        }
        
        return nil
    }
    
    public var isScrollable: Bool {
        switch self {
        case .scrollableHorizontal, .scrollableVertical: return true
        default: return false
        }
    }
    
    public var isGauge: Bool {
        switch self {
        case .gauge: return true
        default: return false
        }
    }
    
    public var isGrid: Bool {
        switch self {
        case .grid: return true
        default: return false
        }
    }
    
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
