// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import Foundation

extension CompactSlider {
    func onDragLocationChange(translation: CGSize, size: CGSize, type: CompactSliderType) {
        guard let startDragLocation, !bounds.isEmpty, size.width > 0 else { return }
        
        let location: CGPoint
        
        if type.isHorizontal {
            var translationX = translation.width
            
            if case .horizontal(.trailing) = type {
                translationX = -translationX
            }
            
            location = CGPoint(x: startDragLocation.x + translationX, y: 0)
        } else if type.isVertical {
            var translationY = translation.height
            
            if case .vertical(.center) = type {
                translationY = -translationY
            }
            
            if case .vertical(.top) = type {
                translationY = -translationY
            }
            
            location = CGPoint(x: 0, y: startDragLocation.y + translationY)
        } else {
            return
        }
        
        return updateProgress(progress(at: location, size: size, type: type), type: type)
    }
        
    func updateProgress(_ newValue: Double, type: CompactSliderType) {
        var newValue = newValue
        let type = progress.isRangeValues ? type.normalizedRangeValuesType : type
        let progressAndIndex = nearestProgress(for: newValue)
        
        guard progressStep > 0 else {
            if progressAndIndex.progress != newValue {
                progress.update(newValue, at: progressAndIndex.index)
                
                if newValue == 1 || newValue == 0 {
                    HapticFeedback.vibrate(disabledHapticFeedback)
                }
            }
            
            return
        }
        
        let roundedValue = (newValue / progressStep).rounded() * progressStep
        
        if progressAndIndex.progress != roundedValue {
            progress.update(roundedValue, at: progressAndIndex.index)
            HapticFeedback.vibrate(disabledHapticFeedback)
        }
    }
}

#if os(macOS)
extension CompactSlider {
    func onScrollWheelChange(
        _ event: ScrollWheelEvent,
        size: CGSize,
        location: CGPoint,
        type: CompactSliderType
    ) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        let type = progress.isRangeValues ? type.normalizedRangeValuesType : type
        let newProgress: Double
        let sensitivity = gestureOptions.scrollWheelSensitivity ?? 0.5
        
        if type.isHorizontal {
            let xProgress = (event.location.x - location.x) / size.width
            let currentProgress = nearestProgress(for: xProgress).progress
            
            let deltaProgressStep = progressStep * (event.delta.x.sign == .minus ? -sensitivity : sensitivity)
            
            if case .horizontal(.trailing) = type {
                newProgress = currentProgress + event.delta.x / -size.width + deltaProgressStep
            } else {
                newProgress = currentProgress + event.delta.x / size.width + deltaProgressStep
            }
        } else if type.isVertical {
            let yProgress = (event.location.y - location.y) / size.height
            let currentProgress = nearestProgress(for: yProgress).progress
            
            let deltaProgressStep = progressStep * (event.delta.y.sign == .minus ? -sensitivity : sensitivity)
            
            if case .vertical(.bottom) = type {
                newProgress = currentProgress + event.delta.y / -size.height + deltaProgressStep
            } else {
                newProgress = currentProgress + event.delta.y / size.height + deltaProgressStep
            }
        } else {
            return
        }
        
        updateProgress(newProgress.clamped(), type: type)
    }
}
#endif

// MARK: - Calculations

extension CompactSlider {
    func progress(at location: CGPoint, size: CGSize, type: CompactSliderType) -> Double {
        if type.isHorizontal {
            return (location.x / size.width).clamped()
        }
        
        if type.isVertical {
            return 1.0 - (location.y / size.height).clamped()
        }
        
        return 0
    }
    
    func progressLocation(_ progress: Double, size: CGSize, type: CompactSliderType) -> CGPoint {
        if type.isHorizontal {
            return CGPoint(x: progress * size.width, y: 0)
            
        }
        
        if type.isVertical {
            return CGPoint(x: 0, y: (1 - progress) * size.height)
        }
        
        return .zero
    }
    
    func nearestProgressLocation(at location: CGPoint, size: CGSize, type: CompactSliderType) -> CGPoint {
        let p: Double
        
        if progress.progresses.count > 1 {
            var progressAtLocation = progress(at: location, size: size, type: type)
            
            if type.isVertical, !progress.isSingularValue {
                progressAtLocation = 1 - progressAtLocation
            }
            
            p = nearestProgress(for: progressAtLocation).progress
        } else {
            p = progress.progress
        }
        
        return progressLocation(p, size: size, type: type)
    }
    
    func nearestProgress(for value: Double) -> (progress: Double, index: Int) {
        guard progress.progresses.count > 1 else {
            return (progress.progress, 0)
        }
        
        var resultProgress = progress.progresses[0]
        var deltaProgress = abs(progress.progresses[0] - value)
        var index = 0
        
        for (i, p) in progress.progresses.enumerated() where abs(p - value) < deltaProgress {
            resultProgress = p
            deltaProgress = abs(p - value)
            index = i
        }
        
        return (resultProgress, index)
    }
}

