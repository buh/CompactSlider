// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import Foundation

extension CompactSlider {
    func onDragLocationChange(_ newValue: CGPoint, size: CGSize, type: CompactSliderType) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        if type.isHorizontal {
            updateProgress(max(0, min(1, newValue.x / size.width)), type: type)
        } else if type.isVertical {
            updateProgress(1 - Double(max(0, min(1, newValue.y / size.height))), type: type)
        }
    }
    
    private func nearestProgress(for value: Double) -> (progress: Double, index: Int) {
        guard progress.progresses.count > 1 else {
            return (progress.lowerProgress, 0)
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
    
    func updateProgress(_ newValue: Double, type: CompactSliderType) {
        var newValue = newValue
        let type = progress.isRangeValues ? type.normalizedRangeValuesType : type
        
        if case .horizontal(.trailing) = type {
            newValue = 1 - newValue
        }
        
        if case .vertical(.center) = type {
            newValue = 1 - newValue
        }
        
        if case .vertical(.top) = type {
            newValue = 1 - newValue
        }
        
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
        let sensetivity = gestureOptions.scrollWheelSensetivity ?? 0.5
        
        if type.isHorizontal {
            let xProgress = (event.location.x - location.x) / size.width
            let currentProgress = nearestProgress(for: xProgress).progress
            
            let deltaProgressStep = progressStep * (event.delta.x.sign == .minus ? -sensetivity : sensetivity)
            
            if case .horizontal(.trailing) = type {
                newProgress = 1 - max(0, min(1, currentProgress + event.delta.x / -size.width + deltaProgressStep))
            } else {
                newProgress = max(0, min(1, currentProgress + event.delta.x / size.width + deltaProgressStep))
            }
        } else if type.isVertical {
            let yProgress = (event.location.y - location.y) / size.height
            let currentProgress = nearestProgress(for: yProgress).progress
            
            let deltaProgressStep = progressStep * (event.delta.y.sign == .minus ? -sensetivity : sensetivity)
            
            if case .vertical(.bottom) = type {
                newProgress = max(0, min(1, currentProgress + event.delta.y / -size.height + deltaProgressStep))
            } else {
                newProgress = 1 - max(0, min(1, currentProgress + event.delta.y / size.height + deltaProgressStep))
            }
        } else {
            return
        }
        
        updateProgress(newProgress, type: type)
    }
}
#endif
