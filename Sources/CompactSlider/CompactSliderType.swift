// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

/// A slider type in which the slider will indicate the selected value.
public enum CompactSliderType: Equatable {
    case horizontal(CompactSliderHorizontalDirection)
    case vertical(CompactSliderVerticalDirection)
    case scrollableHorizontal
    case scrollableVertical
    case panel
    
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
    
    public var horizontalDirection: CompactSliderHorizontalDirection? {
        if case .horizontal(let direction) = self {
            return direction
        }
        
        return nil
    }
    
    public var verticalDirection: CompactSliderVerticalDirection? {
        if case .vertical(let direction) = self {
            return direction
        }
        
        return nil
    }
    
    public var isScrollable: Bool {
        switch self {
        case .scrollableHorizontal, .scrollableVertical: return true
        default: return false
        }
    }
}

/// A direction in which the slider will indicate the selected value.
public enum CompactSliderDirection: Sendable {
    case horizontal
    case vertical
}

/// A direction in which the slider will indicate the selected horizontal value.
public enum CompactSliderHorizontalDirection {
    /// The selected value will be indicated from the lower left-hand area of the boundary.
    case leading
    /// The selected value will be indicated from the centre.
    case center
    /// The selected value will be indicated from the upper right-hand area of the boundary.
    case trailing
}

/// A direction in which the slider will indicate the selected vertical value.
public enum CompactSliderVerticalDirection {
    /// The selected value will be indicated from the lower top-hand area of the boundary.
    case top
    /// The selected value will be indicated from the centre.
    case center
    /// The selected value will be indicated from the lower bottom-hand area of the boundary.
    case bottom
}
