// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// Configuration for creating a style for the slider.
public struct CompactSliderStyleConfiguration {
    /// A slider type in which the slider will indicate the selected value.
    public let type: CompactSliderType
    /// The slider size.
    public let size: CGSize
    /// True, when hovering the slider.
    public let isHovering: Bool
    /// True, when dragging the slider.
    public let isDragging: Bool
    /// Progress values represents the position of the selected value within bounds, mapped into 0...1.
    public let progresses: [Double]
}

public extension CompactSliderStyleConfiguration {
    var isFocused: Bool { isHovering || isDragging }
    /// True if the slider uses a single value.
    var isSingularValue: Bool { progresses.count == 1 }
    /// True if the slider uses a range of values.
    var isRangeValues: Bool { progresses.count == 2 }
    /// True if the slider uses multiple values.
    var isMultipleValues: Bool { progresses.count > 2 }
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    var progress: Double { progresses.first ?? 0 }
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    /// This progress should be used to track a single value or a lower value for a range of values.
    var lowerProgress: Double { progresses.first ?? 0 }
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    /// This progress should only be used to track the upper value for the range of values.
    var upperProgress: Double { progresses.last ?? 0 }
}

public extension CompactSliderStyleConfiguration {
    func sliderSize() -> OptionalCGSize {
        switch type {
        case .horizontal, .scrollableHorizontal:
            OptionalCGSize(width: size.width)
        case .vertical, .scrollableVertical:
            OptionalCGSize(height: size.height)
        case .panel:
            OptionalCGSize(width: size.width, height: size.height)
        }
    }
    
    func progressSize() -> OptionalCGSize {
        if isMultipleValues {
            return OptionalCGSize()
        }
        
        var progress = isRangeValues ? abs(upperProgress - lowerProgress) : lowerProgress
        print("progress", progress)
        
        switch type {
        case .horizontal(let direction):
            switch direction {
            case .leading, .trailing:
                break
            case .center:
                progress = abs(progress - 0.5)
            }
            
            return OptionalCGSize(width: size.width * progress)
        case .vertical(let direction):
            switch direction {
            case .top, .bottom:
                break
            case .center:
                progress = abs(progress - 0.5)
            }
            
            return OptionalCGSize(height: size.height * progress)
        default:
            return OptionalCGSize()
        }
    }
    
    func progressOffset() -> CGPoint {
        if isMultipleValues {
            return .zero
        }
        
        if isRangeValues {
            switch type {
            case .horizontal:
                return CGPoint(x: size.width * min(lowerProgress, upperProgress), y: 0)
            case .vertical:
                return CGPoint(x: 0, y: size.width * min(lowerProgress, upperProgress))
            default:
                return CGPoint.zero
            }
        }
        
        switch type {
        case .horizontal(let direction):
            switch direction {
            case .leading:
                return CGPoint.zero
            case .center:
                if progress > 0.5 {
                    return CGPoint(x: size.width / 2, y: 0)
                }
                
                let progressSize = progressSize()
                return CGPoint(x: size.width / 2 - (progressSize.width ?? 0), y: 0)
            case .trailing:
                let progressSize = progressSize()
                return CGPoint(x: size.width - (progressSize.width ?? 0), y: 0)
            }
        case .vertical(let direction):
            switch direction {
            case .top:
                return CGPoint.zero
            case .center:
                if progress > 0.5 {
                    return CGPoint(x: 0, y: size.height / 2)
                }
                
                let progressSize = progressSize()
                return CGPoint(x: 0, y: size.height / 2 - (progressSize.height ?? 0))
            case .bottom:
                let progressSize = progressSize()
                return CGPoint(x: 0, y: size.height - (progressSize.height ?? 0))
            }
        default:
            return CGPoint.zero
        }
    }
    
    func offset(at index: Int, handleWidth: CGFloat = 0) -> CGPoint {
        guard index < progresses.count else { return .zero }
        
        switch type {
        case .horizontal(let direction):
            switch direction {
            case .leading, .center:
                return CGPoint(x: (size.width - handleWidth) * progresses[index], y: 0)
            case .trailing:
                return CGPoint(x: size.width - handleWidth - (size.width - handleWidth) * progresses[index], y: 0)
            }
        case .vertical(let direction):
            switch direction {
            case .top, .center:
                return CGPoint(x: 0, y: (size.height - handleWidth) * progresses[index])
            case .bottom:
                return CGPoint(x: 0, y: size.height - handleWidth - (size.height - handleWidth) * progresses[index])
            }
        default:
            return .zero
        }
    }
}
