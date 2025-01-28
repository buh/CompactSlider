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
    /// The possible color schemes, corresponding to the light and dark appearances.
    public let colorScheme: ColorScheme
    
    public func progress(at index: Int) -> Double {
        index < progress.progresses.count ? progress.progresses[index] : 0
    }
    
    init(
        type: CompactSliderType,
        size: CGSize,
        focusState: FocusState,
        progress: Progress,
        step: CompactSliderStep?,
        colorScheme: ColorScheme
    ) {
        self.type = type
        self.size = size
        self.focusState = focusState
        self.progress = progress
        self.step = step
        self.colorScheme = colorScheme
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
        case .grid, .circularGrid:
            OptionalCGSize(width: size.width, height: size.height)
        }
    }
}

// MARK: - Progress

extension CompactSliderStyleConfiguration {
    func handleWidth(handleStyle: HandleStyle) -> CGFloat {
        switch handleStyle.visibility {
        case .always:
            break
        case .hidden:
            return 0
        case .focused:
            guard focusState.isFocused else { return 0 }
            break
        }
        
        return handleStyle.width
    }
    
    public func progressSize(handleStyle: HandleStyle) -> OptionalCGSize {
        if progress.isMultipleValues || type.isScrollable {
            return OptionalCGSize()
        }
        
        let isRangeValues = progress.isRangeValues
        let type = isRangeValues ? type.normalizedRangeValuesType : type
        var progress = isRangeValues ? abs(progress.upperProgress - progress.lowerProgress) : progress.progress
        
        let progressHandleWidth = handleWidth(handleStyle: handleStyle)
        var offset: CGFloat
        
        switch handleStyle.progressAlignment {
        case .inside:
            if type.isCenter {
                offset = progressHandleWidth / 2
            } else {
                offset = progressHandleWidth
            }
        case .center:
            offset = (type.isCenter || isRangeValues ? 0 : progressHandleWidth / 2)
        case .outside:
            if isRangeValues {
                offset = -progressHandleWidth
            } else if type.isCenter {
                offset = progressHandleWidth / -2
            } else {
                offset = 0
            }
        }
        
        if handleStyle.visibility == .focused, !focusState.isFocused {
            offset = 0
        }
        
        switch type {
        case .horizontal(let alignment):
            switch alignment {
            case .leading, .trailing:
                break
            case .center:
                progress = abs(progress - 0.5)
            }
            
            return OptionalCGSize(width: offset + (size.width - progressHandleWidth) * progress)
        case .vertical(let alignment):
            switch alignment {
            case .top, .bottom:
                break
            case .center:
                progress = abs(progress - 0.5)
            }
            
            return OptionalCGSize(height: offset + (size.height - progressHandleWidth) * progress)
        default:
            return OptionalCGSize()
        }
    }
    
    public func progressOffset(handleStyle: HandleStyle) -> CGPoint {
        if progress.isMultipleValues || type.isScrollable {
            return .zero
        }
        
        if progress.isRangeValues {
            var offset: CGFloat = handleWidth(handleStyle: handleStyle) / 2
            
            if handleStyle.progressAlignment == .inside {
                offset = 0
            }
            
            if handleStyle.progressAlignment == .outside {
                offset = handleWidth(handleStyle: handleStyle)
            }
            
            switch type {
            case .horizontal:
                return CGPoint(
                    x: (size.width - handleWidth(handleStyle: handleStyle))
                        * min(progress.lowerProgress, progress.upperProgress)
                        + offset,
                    y: 0
                )
            case .vertical:
                return CGPoint(
                    x: 0,
                    y: (size.height - handleWidth(handleStyle: handleStyle))
                        * min(progress.lowerProgress, progress.upperProgress)
                        + offset
                )
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
                
                let progressSize = progressSize(handleStyle: handleStyle)
                return CGPoint(x: size.width / 2 - (progressSize.width ?? 0), y: 0)
            case .trailing:
                let progressSize = progressSize(handleStyle: handleStyle)
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
                
                let progressSize = progressSize(handleStyle: handleStyle)
                return CGPoint(x: 0, y: size.height / 2 - (progressSize.height ?? 0))
            case .bottom:
                let progressSize = progressSize(handleStyle: handleStyle)
                return CGPoint(x: 0, y: size.height - (progressSize.height ?? 0))
            }
        default:
            return CGPoint.zero
        }
    }
}

// MARK: - Handle

extension CompactSliderStyleConfiguration {
    public func handleOffset(at index: Int, handleStyle: HandleStyle) -> CGPoint {
        guard index < progress.progresses.count else { return .zero }
        
        var handleWidth = handleStyle.width
        
        if type.isHorizontal {
            handleWidth = handleWidth == 0 ? size.height : handleWidth
        } else if type.isVertical {
            handleWidth = handleWidth == 0 ? size.width : handleWidth
        }
        
        let type = progress.isRangeValues || progress.isMultipleValues ? type.normalizedRangeValuesType : type
        
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
    
    public func isHandleVisible(handleStyle: HandleStyle) -> Bool {
        if progress.isMultipleValues
            || progress.isGridValues
            || progress.isCircularGridValues
            || type.isScrollable {
            return true
        }
        
        guard handleStyle.visibility == .focused else {
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
    
    public func isScaleVisible(visibility: CompactSliderVisibility) -> Bool {
        if type.isScrollable {
            return true
        }
        
        return visibility != .hidden
            && (type.isHorizontal || type.isVertical || type.isCircularGrid)
            && (visibility == .always || focusState.isFocused)
    }
}

// MARK: - Scale

extension CompactSliderStyleConfiguration {
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
        colorScheme: .light
    )
}

extension EnvironmentValues {
    var compactSliderStyleConfiguration: CompactSliderStyleConfiguration {
        get { self[CompactSliderStyleConfigurationKey.self] }
        set { self[CompactSliderStyleConfigurationKey.self] = newValue }
    }
}

// MARK: - Preview

#if DEBUG
extension CompactSliderStyleConfiguration {
    static func preview(size: CGSize = .zero) -> CompactSliderStyleConfiguration {
        .init(
            type: .horizontal(.leading),
            size: size,
            focusState: .none,
            progress: .init(),
            step: nil,
            colorScheme: .light
        )
    }
}
#endif
