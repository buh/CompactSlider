// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import Foundation

extension CompactSlider {
    func onDragLocationChange(_ newValue: CGPoint, size: CGSize) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        if type.isHorizontal {
            updateProgress(max(0, min(1, newValue.x / size.width)))
        } else if type.isVertical {
            updateProgress(1 - Double(max(0, min(1, newValue.y / size.height))))
        }
    }
    
    private func nearestProgress(for value: Double) -> (progress: Double, index: Int) {
        guard progresses.count > 1 else {
            return (lowerProgress, 0)
        }
        
        var progress = progresses[0]
        var deltaProgress = abs(progresses[0] - value)
        var index = 0
        
        for (i, p) in progresses.enumerated() where abs(p - value) < deltaProgress {
            progress = p
            deltaProgress = abs(p - value)
            index = i
        }
        
        return (progress, index)
    }
    
    func updateProgress(_ newValue: Double) {
        var newValue = newValue
        
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
                updateProgress(newValue, at: progressAndIndex.index)
                
                if newValue == 1 || newValue == 0 {
                    HapticFeedback.vibrate(disabledHapticFeedback)
                }
            }
            
            return
        }
        
        let roundedValue = (newValue / progressStep).rounded() * progressStep
        
        if progressAndIndex.progress != roundedValue {
            updateProgress(roundedValue, at: progressAndIndex.index)
            HapticFeedback.vibrate(disabledHapticFeedback)
        }
    }
}

#if os(macOS)
extension CompactSlider {
    func onScrollWheelChange(_ event: ScrollWheelEvent, size: CGSize, location: CGPoint) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        let newProgress: Double
        
        if type.isHorizontal {
            let xProgress = (event.location.x - location.x) / size.width
            let currentProgress = nearestProgress(for: xProgress).progress
            
            let deltaProgressStep = progressStep * (event.delta.x.sign == .minus ? -0.5 : 0.5)
            
            if case .horizontal(.trailing) = type {
                newProgress = 1 - max(0, min(1, currentProgress + event.delta.x / -size.width + deltaProgressStep))
            } else {
                newProgress = max(0, min(1, currentProgress + event.delta.x / size.width + deltaProgressStep))
            }
        } else if type.isVertical {
            let yProgress = (event.location.y - location.y) / size.height
            let currentProgress = nearestProgress(for: yProgress).progress
            
            let deltaProgressStep = progressStep * (event.delta.y.sign == .minus ? -0.5 : 0.5)
            
            if case .vertical(.bottom) = type {
                newProgress = max(0, min(1, currentProgress + event.delta.y / -size.height + deltaProgressStep))
            } else {
                newProgress = 1 - max(0, min(1, currentProgress + event.delta.y / size.height + deltaProgressStep))
            }
        } else {
            return
        }
        
        updateProgress(newProgress)
    }
}
#endif
