// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// Configuration for creating a style for the slider.
public struct CompactSliderStyleConfiguration: Equatable {
    /// A slider type in which the slider will indicate the selected value.
    public let type: CompactSliderType
    /// The slider size.
    public let size: CGSize
    /// A dragging or hovering state of the slider.
    public let focusState: FocusState
    /// Progress values represents the position of the selected value within bounds, mapped into 0...1.
    public let progress: Progress
    public let steps: Int
}

public extension CompactSliderStyleConfiguration {
    /// A dragging or hovering state of the slider.
    struct FocusState: Equatable {
        /// True, when hovering the slider.
        public var isHovering: Bool
        /// True, when dragging the slider.
        public var isDragging: Bool
        /// True, when dragging or hovering the slider.
        public var isFocused: Bool { isHovering || isDragging }
        
        public init(isHovering: Bool, isDragging: Bool) {
            self.isHovering = isHovering
            self.isDragging = isDragging
        }
    }
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
        if progress.isMultipleValues {
            return OptionalCGSize()
        }
        
        var progress = progress.isRangeValues ? abs(progress.upperProgress - progress.lowerProgress) : progress.lowerProgress
        
        switch type {
        case .horizontal(let alignment):
            switch alignment {
            case .leading, .trailing:
                break
            case .center:
                progress = abs(progress - 0.5)
            }
            
            return OptionalCGSize(width: size.width * progress)
        case .vertical(let alignment):
            switch alignment {
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
        if progress.isMultipleValues {
            return .zero
        }
        
        if progress.isRangeValues {
            switch type {
            case .horizontal:
                return CGPoint(x: size.width * min(progress.lowerProgress, progress.upperProgress), y: 0)
            case .vertical:
                return CGPoint(x: 0, y: size.height * min(progress.lowerProgress, progress.upperProgress))
            default:
                return CGPoint.zero
            }
        }
        
        switch type {
        case .horizontal(let alignment):
            switch alignment {
            case .leading:
                return CGPoint.zero
            case .center:
                if progress.progress > 0.5 {
                    return CGPoint(x: size.width / 2, y: 0)
                }
                
                let progressSize = progressSize()
                return CGPoint(x: size.width / 2 - (progressSize.width ?? 0), y: 0)
            case .trailing:
                let progressSize = progressSize()
                return CGPoint(x: size.width - (progressSize.width ?? 0), y: 0)
            }
        case .vertical(let alignment):
            switch alignment {
            case .top:
                return CGPoint.zero
            case .center:
                if progress.progress > 0.5 {
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
        guard index < progress.progresses.count else { return .zero }
        
        let type = progress.isRangeValues ? type.normalizedRangeValuesType : type
        
        switch type {
        case .horizontal(let alignment):
            switch alignment {
            case .leading, .center:
                return CGPoint(x: (size.width - handleWidth) * progress.progresses[index], y: 0)
            case .trailing:
                return CGPoint(x: size.width - handleWidth - (size.width - handleWidth) * progress.progresses[index], y: 0)
            }
        case .vertical(let alignment):
            switch alignment {
            case .top, .center:
                return CGPoint(x: 0, y: (size.height - handleWidth) * progress.progresses[index])
            case .bottom:
                return CGPoint(x: 0, y: size.height - handleWidth - (size.height - handleWidth) * progress.progresses[index])
            }
        default:
            return .zero
        }
    }
}

// MARK: - Handle

public extension CompactSliderStyleConfiguration {
    func isHandleVisible(handleStyle: HandleStyle) -> Bool {
        guard handleStyle.visibility == .hoveringOrDragging else {
            return handleStyle.visibility == .always
        }
        
        if focusState.isFocused {
            return true
        }
        
        guard progress.isSingularValue else {
            return false
        }
        
        if type.isHorizontal {
            if type.horizontalAlignment == .center {
                return progress.progress == 0.5
            }
            
            return progress.progress == 0
        }
        
        if type.isVertical {
            if type.verticalAlignment == .center {
                return progress.progress == 0.5
            }
            
            return progress.progress == 0
        }
        
        return false
    }
    
    func isScaleVisible(scaleStyle: ScaleStyle) -> Bool {
        scaleStyle.visibility != .hidden
            && (type.isHorizontal || type.isVertical)
            && (scaleStyle.visibility == .always || focusState.isFocused)
    }
}

// MARK: - Environment

struct CompactSliderStyleConfigurationKey: EnvironmentKey {
    static var defaultValue: CompactSliderStyleConfiguration = CompactSliderStyleConfiguration(
        type: .horizontal(.leading),
        size: .zero,
        focusState: .init(isHovering: false, isDragging: false),
        progress: Progress(),
        steps: 0
    )
}

extension EnvironmentValues {
    var compactSliderStyleConfiguration: CompactSliderStyleConfiguration {
        get { self[CompactSliderStyleConfigurationKey.self] }
        set { self[CompactSliderStyleConfigurationKey.self] = newValue }
    }
}
