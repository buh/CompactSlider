// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import Foundation

extension CompactSlider {
    func onDragLocationChange(
        translation: CGSize,
        size: CGSize,
        type: CompactSliderType,
        isEnded: Bool,
        isRightToLeft: Bool
    ) {
        guard let startDragLocation, !bounds.isEmpty, size.width > 0 else { return }
        
        let location: CGPoint
        
        if type.isHorizontal {
            var translationX = translation.width
            
            if isRightToLeft {
                translationX = -translationX
            }
            
            if case .horizontal(.trailing) = type {
                translationX = -translationX
            }
            
            if type.isScrollable {
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
            
            if type.isScrollable {
                translationY = -translationY
            }
            
            location = CGPoint(x: 0, y: startDragLocation.y + translationY)
        } else if type == .grid {
            var translationX = translation.width
            
            if isRightToLeft {
                translationX = -translationX
            }
            
            let locationX = CGPoint(x: startDragLocation.x + translationX, y: 0)
            let locationY = CGPoint(x: 0, y: startDragLocation.y + translation.height)
            
            let progressX = progress(at: locationX, size: size, type: .scrollableHorizontal)
                .clampedOrRotated(withRotaion: options.contains(.loopValues))
            
            let progressY = 1 - progress(at: locationY, size: size, type: .scrollableVertical)
                .clampedOrRotated(withRotaion: options.contains(.loopValues))
            
            if progressX != progress.progresses[0] || progressY != progress.progresses[1] {
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
        
        return updateProgress(progress(at: location, size: size, type: type), isEnded: isEnded)
    }
    
    func updateProgress(_ newValue: Double, isEnded: Bool) {
        let newValue = newValue.clampedOrRotated(withRotaion: options.contains(.loopValues))
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
        
        guard isEnded || options.contains(.snapToSteps) else {
            if progressAndIndex.progress != newValue {
                progress.update(newValue, at: progressAndIndex.index)
            }
            
            return
        }
        
        let roundedValue = newValue.rounded(toStep: progressStep)
        
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
        type: CompactSliderType,
        isRightToLeft: Bool
    ) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        let type = progress.isRangeValues ? type.normalizedRangeValuesType : type
        let newProgress: Double
        
        if type.isHorizontal {
            var xProgress = (event.location.x - location.x) / size.width
            
            if isRightToLeft {
                xProgress = 1 - xProgress
            }
            
            let currentProgress = nearestProgress(for: xProgress).progress
            
            if event.isEnded {
                if !options.contains(.snapToSteps) {
                    updateProgress(currentProgress, isEnded: true)
                }
                
                return
            }
            
            if steps > 0, options.contains(.snapToSteps) {
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
        } else if type.isVertical {
            let yProgress = (event.location.y - location.y) / size.height
            let currentProgress = nearestProgress(for: yProgress).progress
            
            if event.isEnded {
                if !options.contains(.snapToSteps) {
                    updateProgress(currentProgress, isEnded: true)
                }
                
                return
            }
            
            if steps > 0, options.contains(.snapToSteps) {
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
        } else {
            return
        }
        
        updateProgress(newProgress, isEnded: false)
    }
}
#endif

// MARK: - Calculations

extension CompactSlider {
    func progress(at location: CGPoint, size: CGSize, type: CompactSliderType) -> Double {
        if type.isHorizontal {
            return (location.x / size.width)
        }
        
        if type.isVertical {
            return 1.0 - (location.y / size.height)
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
    
    func nearestProgressLocation(
        at location: CGPoint,
        size: CGSize,
        type: CompactSliderType,
        isRightToLeft: Bool
    ) -> CGPoint {
        guard type != .grid else {
            return CGPoint(
                x: progressLocation(progress.progresses[0], size: size, type: .scrollableHorizontal).x,
                y: progressLocation(1 - progress.progresses[1], size: size, type: .scrollableVertical).y
            )
        }
        
        let p: Double
        
        if progress.progresses.count > 1 {
            var progressAtLocation = progress(at: location, size: size, type: type)
            
            if isRightToLeft || (type.isVertical && !progress.isSingularValue) {
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

