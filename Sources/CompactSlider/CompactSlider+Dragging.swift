// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import Foundation

extension CompactSlider {
    func onDragLocationXChange(_ newValue: CGFloat, size: CGSize) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        updateProgress(max(0, min(1, newValue / size.width)))
    }
    
    func onDeltaLocationXChange(_ newDelta: CGFloat, size: CGSize) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        let deltaProgressStep = progressStep * (newDelta.sign == .minus ? -0.5 : 0.5)
        let newProgress = max(0, min(1, lowerProgress + newDelta / size.width + deltaProgressStep))
        updateProgress(newProgress)
    }
    
    func updateProgress(_ newValue: Double) {
        let isProgress2Nearest: Bool
        
        // Check which progress is closest and should be in focus.
        if abs(upperProgress - lowerProgress) < 0.01 {
            isProgress2Nearest = newValue > upperProgress
        } else {
            isProgress2Nearest = isRangeValues && abs(lowerProgress - newValue) > abs(upperProgress - newValue)
        }
        
        guard progressStep > 0 else {
            if isProgress2Nearest {
                if upperProgress != newValue {
                    upperProgress = newValue
                    
                    if upperProgress == 1 {
                        HapticFeedback.vibrate(disabledHapticFeedback)
                    }
                }
            } else if lowerProgress != newValue {
                lowerProgress = newValue
                
                if lowerProgress == 0 || lowerProgress == 1 {
                    HapticFeedback.vibrate(disabledHapticFeedback)
                }
            }
            
            return
        }
        
        let rounded = (newValue / progressStep).rounded() * progressStep
        
        if isProgress2Nearest {
            if rounded != upperProgress {
                upperProgress = rounded
                HapticFeedback.vibrate(disabledHapticFeedback)
            }
        } else if rounded != lowerProgress {
            lowerProgress = rounded
            HapticFeedback.vibrate(disabledHapticFeedback)
        }
    }
    
    func onLowerProgressChange(_ newValue: Double) {
        isLowerValueChangingInternally = true
        lowerValue = convertProgressToValue(newValue)
        DispatchQueue.main.async { isLowerValueChangingInternally = false }
    }
    
    func onUpperProgressChange(_ newValue: Double) {
        isUpperValueChangingInternally = true
        upperValue = convertProgressToValue(newValue)
        DispatchQueue.main.async { isUpperValueChangingInternally = false }
    }
    
    func convertProgressToValue(_ newValue: Double) -> Value {
        let value = bounds.lowerBound + Value(newValue) * bounds.length
        return step > 0 ? (value / step).rounded() * step : value
    }
    
    func onLowerValueChange(_ newValue: Value) {
        if isLowerValueChangingInternally { return }
        lowerProgress = convertValueToProgress(newValue)
    }
    
    func onUpperValueChange(_ newValue: Value) {
        if isUpperValueChangingInternally { return }
        upperProgress = convertValueToProgress(newValue)
    }
    
    func convertValueToProgress(_ newValue: Value) -> Double {
        let length = Double(bounds.length)
        return length != 0 ? Double(newValue - bounds.lowerBound) / length : 0
    }
}
