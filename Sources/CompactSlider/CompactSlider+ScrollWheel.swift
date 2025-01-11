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
        
        let type = progress.isRangeValues ? type.normalizedRangeValuesType : type
        let newProgress: Double
        
        if type.isHorizontal,
           let progress = onScrollWheelHorizontalProgress(
            event,
            size: size,
            location: location,
            type: type,
            isRightToLeft: isRightToLeft
           ) {
            newProgress = progress
        } else if type.isVertical,
                  let progress = onScrollWheelVerticalProgress(
                    event,
                    size: size,
                    location: location,
                    type: type,
                    isRightToLeft: isRightToLeft
                  ) {
            newProgress = progress
        } else if type == .grid {
            let progressX = onScrollWheelHorizontalProgress(
                event,
                size: size,
                location: location,
                type: type,
                isRightToLeft: isRightToLeft
            )?.clamped()
            
            let progressY = onScrollWheelVerticalProgress(
              event,
              size: size,
              location: location,
              type: type,
              isRightToLeft: isRightToLeft
            )?.clamped()
            
            if let progressX,
               let progressY,
               (progressX != progress.progresses[0] || progressY != progress.progresses[1]) {
                if progressX != progress.progresses[0] {
                    progress.update(progressX, at: 0)
                }
                
                if progressY != progress.progresses[1] {
                    progress.update(progressY, at: 1)
                }
                
                if progressX == 1 || progressX == 0 || progressY == 1 || progressY == 0 {
                    HapticFeedback.vibrate(disabledHapticFeedback)
                }
            }
            
            return

        } else {
            return
        }
        
        updateProgress(newProgress, isEnded: false)
    }
    
    func onScrollWheelHorizontalProgress(
        _ event: ScrollWheelEvent,
        size: CGSize,
        location: CGPoint,
        type: CompactSliderType,
        isRightToLeft: Bool
    ) -> Double? {
        let newProgress: Double
        var progressX = (event.location.x - location.x) / size.width
        
        if isRightToLeft {
            progressX = 1 - progressX
        }
        
        let currentProgress: Double
        
        if type == .grid {
            currentProgress = progress.progresses[0]
        } else {
            currentProgress = nearestProgress(for: progressX).progress
        }
        
        if event.isEnded {
            if !options.contains(.snapToSteps) {
                updateProgress(currentProgress, isEnded: true)
            }
            
            return nil
        }
        
        if let step, options.contains(.snapToSteps) {
            var deltaProgressStep = (event.delta.x.sign == .minus
                                     ? -step.linearProgressStep : step.linearProgressStep)
            
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
        isRightToLeft: Bool
    ) -> Double? {
        let newProgress: Double
        let progressY = (event.location.y - location.y) / size.height
        let currentProgress: Double
        
        if type == .grid {
            currentProgress = progress.progresses[1]
        } else {
            currentProgress = nearestProgress(for: progressY).progress
        }
        
        if event.isEnded {
            if !options.contains(.snapToSteps) {
                updateProgress(currentProgress, isEnded: true)
            }
            
            return nil
        }
        
        if let step, options.contains(.snapToSteps) {
            let deltaProgressStep = (event.delta.y.sign == .minus ? -1 : 1) * step.linearProgressStep
            
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
