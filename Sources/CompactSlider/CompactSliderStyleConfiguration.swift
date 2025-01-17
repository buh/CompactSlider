// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
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
    public let step: CompactSliderStep?
    /// Slider options.
    public let options: Set<CompactSliderOption>
    
    public func progress(at index: Int) -> Double {
        guard index < progress.progresses.count else { return 0 }
        
        return progress.progresses[index]
    }
    
    init(
        type: CompactSliderType,
        size: CGSize,
        focusState: FocusState,
        progress: Progress,
        step: CompactSliderStep?,
        options: Set<CompactSliderOption>
    ) {
        self.type = type
        self.size = size
        self.focusState = focusState
        self.progress = progress
        self.step = step
        self.options = options
    }
}

extension CompactSliderStyleConfiguration {
    /// A dragging or hovering state of the slider.
    public struct FocusState: Equatable {
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
        
        public static var none = FocusState(isHovering: false, isDragging: false)
    }
}

extension CompactSliderStyleConfiguration {
    public func sliderSize() -> OptionalCGSize {
        switch type {
        case .horizontal, .scrollableHorizontal:
            OptionalCGSize(width: size.width)
        case .vertical, .scrollableVertical:
            OptionalCGSize(height: size.height)
        case .gauge:
            OptionalCGSize(width: size.minValue, height: size.minValue)
        case .grid, .circularGrid:
            OptionalCGSize(width: size.width, height: size.height)
        }
    }
    
    public func progressSize() -> OptionalCGSize {
        if progress.isMultipleValues || type.isScrollable {
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
    
    public func progressOffset() -> CGPoint {
        if progress.isMultipleValues || type.isScrollable {
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
    
    public func handleOffset(at index: Int, handleWidth: CGFloat) -> CGPoint {
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
        case .scrollableHorizontal:
            return CGPoint(x: (size.width - handleWidth) / 2, y: 0)
        case .scrollableVertical:
            return CGPoint(x: 0, y: (size.height - handleWidth) / 2)
        case .gauge:
            return .zero // TODO: Gauge
        case .grid:
            return CGPoint(
                x: (size.width - handleWidth) * progress.progresses[0],
                y: (size.height - handleWidth) * progress.progresses[1]
            )
        case .circularGrid:
            let location = progress.polarPoint.toCartesian(size: size)
            return CGPoint(x: location.x - handleWidth / 2, y: location.y - handleWidth / 2)
        }
    }
    
    public func scaleOffset() -> CGPoint {
        guard type.isScrollable, progress.isSingularValue else { return .zero }
        
        switch type {
        case .scrollableHorizontal:
            return CGPoint(x: size.width * (0.5 - progress.progress), y: 0)
        case .scrollableVertical:
            return CGPoint(x: 0, y: size.height * (progress.progress - 0.5))
        default:
            return .zero
        }
    }
}

// MARK: - Handle

extension CompactSliderStyleConfiguration {
    public func isHandleVisible(handleStyle: HandleStyle) -> Bool {
        if progress.isMultipleValues
            || progress.isGridValues
            || progress.isCircularGridValues
            || type.isScrollable {
            return true
        }
        
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
    
    public func isScaleVisible(scaleStyle: ScaleStyle) -> Bool {
        if type.isScrollable {
            return true
        }
        
        return scaleStyle.visibility != .hidden
            && (type.isHorizontal || type.isVertical)
            && (scaleStyle.visibility == .always || focusState.isFocused)
    }
}

// MARK: - Grid

extension CompactSliderStyleConfiguration {
    public var pointSteps: CompactSliderStep.PointSteps {
        step?.pointSteps ?? .init(x: 11, y: 11)
    }
}

// MARK: - Environment

struct CompactSliderStyleConfigurationKey: EnvironmentKey {
    static var defaultValue: CompactSliderStyleConfiguration = CompactSliderStyleConfiguration(
        type: .horizontal(.leading),
        size: .zero,
        focusState: .init(isHovering: false, isDragging: false),
        progress: Progress(),
        step: nil,
        options: []
    )
}

extension EnvironmentValues {
    var compactSliderStyleConfiguration: CompactSliderStyleConfiguration {
        get { self[CompactSliderStyleConfigurationKey.self] }
        set { self[CompactSliderStyleConfigurationKey.self] = newValue }
    }
}
