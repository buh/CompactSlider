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
            
            let location = CGPoint(x: startDragLocation.x + translationX, y: 0)
            updateLinearProgress(progress(at: location, size: size, type: type), isEnded: isEnded)
            return
        }
        
        if type.isVertical {
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
            
            let location = CGPoint(x: 0, y: startDragLocation.y + translationY)
            updateLinearProgress(progress(at: location, size: size, type: type), isEnded: isEnded)
            return
        }
        
        if type == .grid {
            if isEnded {
                if !options.contains(.snapToSteps), let pointProgressStep = step?.pointProgressStep {
                    let progressX = progress.progresses[0].rounded(toStep: pointProgressStep.x)
                    let progressY = progress.progresses[1].rounded(toStep: pointProgressStep.y)
                    
                    progress.update(progressX, at: 0)
                    progress.update(progressY, at: 1)
                    HapticFeedback.vibrate(disabledHapticFeedback)
                }
                
                return
            }
            
            var translationX = translation.width
            
            if isRightToLeft {
                translationX = -translationX
            }
            
            let locationX = CGPoint(x: startDragLocation.x + translationX, y: 0)
            let locationY = CGPoint(x: 0, y: startDragLocation.y + translation.height)
            var progressX = progress(at: locationX, size: size, type: .scrollableHorizontal).clamped()
            var progressY = 1 - progress(at: locationY, size: size, type: .scrollableVertical).clamped()
            
            let isSnapped = options.contains(.snapToSteps) && step?.pointProgressStep != nil
            
            if isSnapped, let pointProgressStep = step?.pointProgressStep {
                progressX = progressX.rounded(toStep: pointProgressStep.x)
                progressY = progressY.rounded(toStep: pointProgressStep.y)
            }
            
            let updatedX = progress.update(progressX, at: 0)
            let updatedY = progress.update(progressY, at: 1)
            
            if (updatedX && (progressX == 1 || progressX == 0))
                || (updatedY && (progressY == 1 || progressY == 0)) {
                HapticFeedback.vibrate(disabledHapticFeedback)
            }
            
            return
        }
    }
    
    func updateLinearProgress(_ newValue: Double, isEnded: Bool) {
        let newValue = newValue.clampedOrRotated(withRotaion: options.contains(.loopValues))
        let progressAndIndex = nearestProgress(for: newValue)
        
        guard let linearProgressStep = step?.linearProgressStep else {
            if progress.update(newValue, at: progressAndIndex.index), (newValue == 1 || newValue == 0) {
                HapticFeedback.vibrate(disabledHapticFeedback)
            }
            
            return
        }
        
        guard isEnded || options.contains(.snapToSteps) else {
            progress.update(newValue, at: progressAndIndex.index)
            return
        }
        
        let roundedValue = newValue.rounded(toStep: linearProgressStep)
        
        if progress.update(roundedValue, at: progressAndIndex.index) {
            HapticFeedback.vibrate(disabledHapticFeedback)
        }
    }
}

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

