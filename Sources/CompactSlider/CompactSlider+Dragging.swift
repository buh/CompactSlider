// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension CompactSlider {
    func dragGestureOnChange(_ value: DragGesture.Value, size: CGSize) {
        if style.type.isHorizontal, abs(value.translation.width) < abs(value.translation.height) {
            return
        }
        
        if style.type.isVertical, abs(value.translation.height) < abs(value.translation.width) {
            return
        }
        
        if startDragTime == nil {
            startDragTime = CFAbsoluteTimeGetCurrent()
        }
        
        if !isDragging {
            if let animation = animations[.dragging] {
                withAnimation(animation) {
                    isDragging = true
                }
            } else {
                isDragging = true
            }
        }
        
        if startDragLocation == nil {
            startDragLocation = nearestProgressLocation(
                at: value.startLocation,
                size: size,
                type: style.type,
                isRightToLeft: layoutDirection == .rightToLeft
            )
        }
        
        dragGestureUpdateProgress(
            translation: value.translation,
            size: size,
            type: style.type,
            isEnded: false,
            isRightToLeft: layoutDirection == .rightToLeft
        )
    }
    
    func dragGestureOnEnded(_ value: DragGesture.Value, size: CGSize) {
        defer {
            startDragTime = nil
            startDragLocation = nil
        }
        
        guard startDragLocation != nil else { return }
        
        if isTap() {
            if let animation = animations[.tapping] {
                withAnimation(animation) {
                    onTap(value, size: size)
                }
            } else {
                onTap(value, size: size)
            }
            
            isDragging = false
            return
        }
        
        if step != nil, !options.contains(.snapToSteps) {
            dragGestureUpdateProgress(
                translation: value.translation,
                size: size,
                type: style.type,
                isEnded: true,
                isRightToLeft: layoutDirection == .rightToLeft
            )
        }
        
        if isDragging {
            if let animation = animations[.dragging] {
                withAnimation(animation) {
                    isDragging = false
                }
            } else {
                isDragging = false
            }
        }
    }
    
    func dragGestureUpdateProgress(
        translation: CGSize,
        size: CGSize,
        type: CompactSliderType,
        isEnded: Bool,
        isRightToLeft: Bool
    ) {
        guard let startDragLocation, !bounds.isEmpty, size.width > 0 else { return }
        
        if type == .grid {
            onDragGridLocationChange(
                translation: translation,
                size: size,
                isEnded: isEnded,
                isRightToLeft: isRightToLeft
            )
            
            return
        }
        
        if type == .circularGrid {
            onDragCircularGridLocationChange(
                translation: translation,
                size: size,
                isEnded: isEnded,
                isRightToLeft: isRightToLeft
            )
            
            return
        }
        
        let type = progress.isRangeValues ? type.normalizedRangeValuesType : type
        
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
            
            if type.isScrollable || progress.isRangeValues || progress.isMultipleValues {
                translationY = -translationY
            } else if case .vertical(.center) = type {
                translationY = -translationY
            } else if case .vertical(.top) = type {
                translationY = -translationY
            }
            
            let location = CGPoint(x: 0, y: startDragLocation.y + translationY)
            let newValue = progress(at: location, size: size, type: type)
            updateLinearProgress(newValue, isEnded: isEnded)
            return
        }
    }
    
    func updateLinearProgress(_ newValue: Double, isEnded: Bool) {
        let newValue = newValue.clampedOrRotated(rotated: options.contains(.loopValues))
        let progressAndIndex = nearestProgress(for: newValue)
        
        guard let linearProgressStep = step?.linearProgressStep else {
            if progress.update(newValue, at: progressAndIndex.index), (newValue == 1 || newValue == 0) {
                HapticFeedback.vibrate(isEnabled: isHapticFeedbackEnabled)
            }
            
            return
        }
        
        guard isEnded || options.contains(.snapToSteps) else {
            progress.update(newValue, at: progressAndIndex.index)
            return
        }
        
        let roundedValue = newValue.rounded(step: linearProgressStep)
        
        if progress.update(roundedValue, at: progressAndIndex.index) {
            HapticFeedback.vibrate(isEnabled: isHapticFeedbackEnabled)
        }
    }
}

// MARK: - Grid

extension CompactSlider {
    func onDragGridLocationChange(
        translation: CGSize,
        size: CGSize,
        isEnded: Bool,
        isRightToLeft: Bool
    ) {
        guard let startDragLocation, size.width > 0, size.height > 0 else { return }
        
        if isEnded {
            updateGridOnEnd()
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
            progressX = progressX.rounded(step: pointProgressStep.x)
            progressY = progressY.rounded(step: pointProgressStep.y)
        }
        
        let updatedX = progress.update(progressX, at: 0)
        let updatedY = progress.update(progressY, at: 1)
        
        if (updatedX && (progressX == 0 || progressX == 1))
            || (updatedY && (progressY == 0 || progressY == 1)) {
            HapticFeedback.vibrate(isEnabled: isHapticFeedbackEnabled)
        }
    }
    
    func updateGridOnEnd() {
        if !options.contains(.snapToSteps), let step = step?.pointProgressStep {
            progress.updatePoint(rounded: step)
            HapticFeedback.vibrate(isEnabled: isHapticFeedbackEnabled)
        }
    }
}

// MARK: - Circular Grid

extension CompactSlider {
    func onDragCircularGridLocationChange(
        translation: CGSize,
        size: CGSize,
        isEnded: Bool,
        isRightToLeft: Bool
    ) {
        let maxDistance = size.minValue / 2
        
        guard let startDragLocation, maxDistance > 0 else { return }
        
        if isEnded {
            updateCircularGridOnEnd()
            return
        }
        
        var translationX = translation.width
        
        if isRightToLeft {
            translationX = -translationX
        }
        
        let newLocation = CGPoint(
            x: startDragLocation.x + translationX,
            y: startDragLocation.y + translation.height
        )
        
        let origin = CGPoint(x: size.minValue / 2, y: size.minValue / 2)
        
        var angle = newLocation.calculateAngle(from: origin)
        angle = angle < .zero ? .degrees(angle.degrees + 360) : angle
        
        let normalizedRadius = newLocation.calculateDistance(from: origin) / maxDistance
        
        updateCircularGrid(
            polarPoint: .init(angle: angle, normalizedRadius: normalizedRadius),
            maxDistance: maxDistance
        )
    }
    
    func updateCircularGridOnEnd() {
        if !options.contains(.snapToSteps), let step = step?.polarPointProgressStep {
            progress.updatePolarPoint(progress.polarPoint.rounded(step))
            HapticFeedback.vibrate(isEnabled: isHapticFeedbackEnabled)
        }
    }
    
    func updateCircularGrid(polarPoint: CompactSliderPolarPoint, maxDistance: CGFloat) {
        var angle = polarPoint.angle
        var normalizedRadius = polarPoint.normalizedRadius
        let isSnapped = options.contains(.snapToSteps) && step?.polarPointProgressStep != nil
        
        if isSnapped, let polarPointProgressStep = step?.polarPointProgressStep {
            let roundedPolarPoint = CompactSliderPolarPoint(
                angle: angle,
                normalizedRadius: normalizedRadius
            ).rounded(polarPointProgressStep)
            
            angle = roundedPolarPoint.angle
            normalizedRadius = roundedPolarPoint.normalizedRadius
        } else if normalizedRadius * maxDistance < 2 {
            angle = .zero
            normalizedRadius = 0
        }
        
        let updated = progress.updatePolarPoint(.init(
            angle: angle,
            normalizedRadius: normalizedRadius
        ))
        
        let degrees = angle.degrees.clamped(0, 360)
        let isAngleSnapped = (degrees == 0 || degrees == 90 || degrees == 180
                              || degrees == 270 || degrees == 360)
        
        if (updated.angle && isAngleSnapped)
            || (updated.radius && (normalizedRadius.clamped() == 0 || normalizedRadius.clamped() == 1)) {
            HapticFeedback.vibrate(isEnabled: isHapticFeedbackEnabled)
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
    
    func nearestProgressLocation(
        at location: CGPoint,
        size: CGSize,
        type: CompactSliderType,
        isRightToLeft: Bool
    ) -> CGPoint {
        guard type != .grid else {
            return CGPoint(
                x: progressLocation(progress.pointProgress.x, size: size, type: .scrollableHorizontal).x,
                y: progressLocation(1 - progress.pointProgress.y, size: size, type: .scrollableVertical).y
            )
        }
        
        guard type != .circularGrid else {
            return progress.polarPoint.toCartesian(size: size)
        }
        
        guard progress.progresses.count > 1 else {
            return progressLocation(progress.progress, size: size, type: type)
        }
        
        var progressAtLocation = progress(at: location, size: size, type: type)
        
        if isRightToLeft || (type.isVertical && (progress.isMultipleValues || progress.isRangeValues)) {
            progressAtLocation = 1 - progressAtLocation
        }
        
        let value = nearestProgress(for: progressAtLocation).progress
        return progressLocation(value, size: size, type: type)
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
    
    func progressLocation(_ progress: Double, size: CGSize, type: CompactSliderType) -> CGPoint {
        if type.isHorizontal {
            return CGPoint(x: progress * size.width, y: 0)
            
        }
        
        if type.isVertical {
            return CGPoint(x: 0, y: (1 - progress) * size.height)
        }
        
        return .zero
    }
}

// MARK: - Tap

extension CompactSlider {
    func isTap() -> Bool {
        guard options.contains(.tapToSlide),
              style.type.isLinear,
              progress.isSingularValue,
              !style.type.isScrollable else {
            return false
        }
        
        return CFAbsoluteTimeGetCurrent() - (startDragTime ?? 0) < 0.25
    }
    
    func onTap(_ value: DragGesture.Value, size: CGSize) {
        updateLinearProgress(
            progress(at: value.location, size: size, type: style.type),
            isEnded: true
        )
    }
}
