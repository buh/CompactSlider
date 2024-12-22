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
    
    func onDeltaLocationChange(_ newDelta: CGPoint, size: CGSize) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        let newProgress: Double
        
        if type.isHorizontal {
            let deltaProgressStep = progressStep * (newDelta.x.sign == .minus ? -0.5 : 0.5)
            
            if case .horizontal(.trailing) = type {
                newProgress = 1 - max(0, min(1, lowerProgress + newDelta.x / -size.width + deltaProgressStep))
            } else {
                newProgress = max(0, min(1, lowerProgress + newDelta.x / size.width + deltaProgressStep))
            }
        } else if type.isVertical {
            let deltaProgressStep = progressStep * (newDelta.y.sign == .minus ? -0.5 : 0.5)
            
            if case .vertical(.bottom) = type {
                newProgress = max(0, min(1, lowerProgress + newDelta.y / -size.height + deltaProgressStep))
            } else {
                newProgress = 1 - max(0, min(1, lowerProgress + newDelta.y / size.height + deltaProgressStep))
            }
        } else {
            return
        }
        
        updateProgress(newProgress)
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
        
        var isProgress2Nearest: Bool = false
        
        // Check which progress is closest and should be in focus.
        if isRangeValues {
            if abs(upperProgress - lowerProgress) < 0.01 {
                isProgress2Nearest = newValue > upperProgress
            } else {
                isProgress2Nearest = isRangeValues && abs(lowerProgress - newValue) > abs(upperProgress - newValue)
            }
        }
        
        guard progressStep > 0 else {
            if isProgress2Nearest {
                if upperProgress != newValue {
                    updateUpperProgress(newValue)
                    
                    if upperProgress == 1 {
                        HapticFeedback.vibrate(disabledHapticFeedback)
                    }
                }
            } else if lowerProgress != newValue {
                updateLowerProgress(newValue)
                
                if lowerProgress == 0 || lowerProgress == 1 {
                    HapticFeedback.vibrate(disabledHapticFeedback)
                }
            }
            
            return
        }
        
        let rounded = (newValue / progressStep).rounded() * progressStep
        
        if isProgress2Nearest {
            if rounded != upperProgress {
                updateUpperProgress(rounded)
                HapticFeedback.vibrate(disabledHapticFeedback)
            }
        } else if rounded != lowerProgress {
            updateLowerProgress(rounded)
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
        let value = bounds.lowerBound + Value(newValue) * bounds.distance
        return step > 0 ? (value / step).rounded() * step : value
    }
    
    func onLowerValueChange(_ newValue: Value) {
        if isLowerValueChangingInternally { return }
        updateLowerProgress(convertValueToProgress(newValue))
    }
    
    func onUpperValueChange(_ newValue: Value) {
        if isUpperValueChangingInternally { return }
        updateUpperProgress(convertValueToProgress(newValue))
    }
    
    func convertValueToProgress(_ newValue: Value) -> Double {
        let length = Double(bounds.distance)
        return length != 0 ? Double(newValue - bounds.lowerBound) / length : 0
    }
}
