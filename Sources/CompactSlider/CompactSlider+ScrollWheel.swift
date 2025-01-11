// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

#if os(macOS)
import Foundation

extension CompactSlider {
    func onScrollWheelChange(
        _ event: ScrollWheelEvent,
        size: CGSize,
        location: CGPoint,
        type: CompactSliderType,
        isRightToLeft: Bool
    ) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        guard type != .grid else {
            onScrollWheelGridChange(event, size: size, location: location, isRightToLeft: isRightToLeft)
            return
        }
        
        let type = progress.isRangeValues ? type.normalizedRangeValuesType : type
        var currentProgress: Double?
        
        if type.isHorizontal {
            currentProgress = onScrollWheelLinearCurrentProgressX(
                event,
                size: size,
                location: location,
                isRightToLeft: isRightToLeft
            )
        } else if type.isVertical {
            currentProgress = onScrollWheelLinearCurrentProgressY(
                event,
                size: size,
                location: location
            )
        }
        
        guard let currentProgress else { return }
        
        if event.isEnded {
            if !options.contains(.snapToSteps) {
                updateLinearProgress(currentProgress, isEnded: true)
            }
            
            return
        }
        
        if type.isHorizontal {
            let newProgress = onScrollWheelHorizontalProgress(
                event,
                size: size,
                location: location,
                type: type,
                isRightToLeft: isRightToLeft,
                currentProgress: currentProgress,
                progressStep: step?.linearProgressStep
            )
            
            updateLinearProgress(newProgress, isEnded: false)
            return
        }
        
        if type.isVertical {
            let newProgress = onScrollWheelVerticalProgress(
                event,
                size: size,
                location: location,
                type: type,
                currentProgress: currentProgress,
                progressStep: step?.linearProgressStep
            )
            
            updateLinearProgress(newProgress, isEnded: false)
            return
        }
    }
    
    func onScrollWheelGridChange(
        _ event: ScrollWheelEvent,
        size: CGSize,
        location: CGPoint,
        isRightToLeft: Bool
    ) {
        if event.isEnded {
            if !options.contains(.snapToSteps), let pointProgressStep = step?.pointProgressStep {
                let progressX = progress.progresses[0].rounded(toStep: pointProgressStep.x)
                let progressY = progress.progresses[1].rounded(toStep: pointProgressStep.y)
                
                progress.update(progressX, at: 0)
                progress.update(progressY, at: 1)
            }
            
            return
        }
        
        let progressX = onScrollWheelHorizontalProgress(
            event,
            size: size,
            location: location,
            type: .grid,
            isRightToLeft: isRightToLeft,
            currentProgress: progress.progresses[0],
            progressStep: step?.pointProgressStep?.x
        ).clamped()
        
        let progressY = onScrollWheelVerticalProgress(
          event,
          size: size,
          location: location,
          type: .grid,
          currentProgress: progress.progresses[1],
          progressStep: step?.pointProgressStep?.y
        ).clamped()
        
        let updatedX = progress.update(progressX, at: 0)
        let updatedY = progress.update(progressY, at: 1)
        
        if (updatedX && (progressX == 1 || progressX == 0))
            || (updatedY && (progressY == 1 || progressY == 0)) {
            HapticFeedback.vibrate(disabledHapticFeedback)
        }
    }
    
    func onScrollWheelLinearCurrentProgressX(
        _ event: ScrollWheelEvent,
        size: CGSize,
        location: CGPoint,
        isRightToLeft: Bool
    ) -> Double {
        var progressX = (event.location.x - location.x) / size.width
        
        if isRightToLeft {
            progressX = 1 - progressX
        }
        
        return nearestProgress(for: progressX).progress
    }
    
    func onScrollWheelLinearCurrentProgressY(
        _ event: ScrollWheelEvent,
        size: CGSize,
        location: CGPoint
    ) -> Double {
        let progressY = (event.location.y - location.y) / size.height
        return nearestProgress(for: progressY).progress
    }
    
    func onScrollWheelHorizontalProgress(
        _ event: ScrollWheelEvent,
        size: CGSize,
        location: CGPoint,
        type: CompactSliderType,
        isRightToLeft: Bool,
        currentProgress: Double,
        progressStep: Double?
    ) -> Double {
        let newProgress: Double
        
        if let progressStep, options.contains(.snapToSteps) {
            var deltaProgressStep = (event.delta.x.sign == .minus ? -progressStep : progressStep)
            
            if isRightToLeft {
                deltaProgressStep = -deltaProgressStep
            }
            
            if type.isScrollable {
                deltaProgressStep = -deltaProgressStep
            }
            
            if case .horizontal(.trailing) = type {
                newProgress = currentProgress - deltaProgressStep
            } else {
                newProgress = currentProgress + deltaProgressStep
            }
        } else {
            var deltaX = (isRightToLeft ? -1 : 1) * event.delta.x
            
            if type.isScrollable {
                deltaX = -deltaX
            }
            
            if case .horizontal(.trailing) = type {
                newProgress = currentProgress + deltaX / -size.width
            } else {
                newProgress = currentProgress + deltaX / size.width
            }
        }
        
        return newProgress
    }
    
    func onScrollWheelVerticalProgress(
        _ event: ScrollWheelEvent,
        size: CGSize,
        location: CGPoint,
        type: CompactSliderType,
        currentProgress: Double,
        progressStep: Double?
    ) -> Double {
        let newProgress: Double
        
        if let progressStep, options.contains(.snapToSteps) {
            let deltaProgressStep = (event.delta.y.sign == .minus ? -1 : 1) * progressStep
            
            if case .vertical(.bottom) = type {
                newProgress = currentProgress - deltaProgressStep
            } else {
                newProgress = currentProgress + deltaProgressStep
            }
        } else {
            if case .vertical(.bottom) = type {
                newProgress = currentProgress + event.delta.y / -size.height
            } else {
                newProgress = currentProgress + event.delta.y / size.height
            }
        }
        
        return newProgress
    }
}
#endif
