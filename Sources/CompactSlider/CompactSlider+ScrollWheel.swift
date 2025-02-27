// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

#if os(macOS)
import Foundation
import SwiftUI

extension CompactSlider {
    func scrollWheelOnChange(_ event: ScrollWheelEvent, size: CGSize, location: CGPoint) {
        guard isHovering else { return }
        
        if !event.isEnded {
            if !isWheelScrolling {
                if let animation = animations[.wheelScrolling] {
                    withAnimation(animation) {
                        isWheelScrolling = true
                    }
                } else {
                    isWheelScrolling = true
                }
            }
            
            if style.type.isHorizontal, !event.isHorizontalDelta {
                return
            }
            
            if style.type.isVertical, event.isHorizontalDelta {
                return
            }
        }
        
        onScrollWheelUpdateProgress(
            event,
            size: size,
            location: location,
            type: style.type,
            isRightToLeft: layoutDirection == .rightToLeft
        )
        
        if event.isEnded, isWheelScrolling {
            if let animation = animations[.wheelScrolling] {
                withAnimation(animation) {
                    isWheelScrolling = false
                }
            } else {
                isWheelScrolling = false
            }
        }
    }
    
    func onScrollWheelUpdateProgress(
        _ event: ScrollWheelEvent,
        size: CGSize,
        location: CGPoint,
        type: CompactSliderType,
        isRightToLeft: Bool
    ) {
        guard !bounds.isEmpty, size.width > 0 else { return }
        
        guard type != .grid else {
            onScrollWheelGridChange(event, size: size, isRightToLeft: isRightToLeft)
            return
        }
        
        guard type != .circularGrid else {
            onScrollWheelCircularGridChange(event, size: size, isRightToLeft: isRightToLeft)
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
                type: type,
                currentProgress: currentProgress,
                progressStep: step?.linearProgressStep
            )
            
            updateLinearProgress(newProgress, isEnded: false)
            return
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
            let deltaX = onScrollWheelDeltaX(event, type: type, isRightToLeft: isRightToLeft)
            newProgress = currentProgress + deltaX / size.width
        }
        
        return newProgress
    }
    
    func onScrollWheelDeltaX(
        _ event: ScrollWheelEvent,
        type: CompactSliderType,
        isRightToLeft: Bool
    ) -> CGFloat {
        var deltaX = (isRightToLeft ? -1 : 1) * event.delta.x
        
        if type.isScrollable {
            deltaX = -deltaX
        }
        
        if case .horizontal(.trailing) = type {
            return deltaX / -1
        }
        
        return deltaX
    }
    
    func onScrollWheelVerticalProgress(
        _ event: ScrollWheelEvent,
        size: CGSize,
        type: CompactSliderType,
        currentProgress: Double,
        progressStep: Double?
    ) -> Double {
        let newProgress: Double
        
        if let progressStep, options.contains(.snapToSteps) {
            var delta = (event.delta.y.sign == .minus ? -1 : 1) * progressStep
            
            if progress.isMultipleValues {
                delta = -delta
            }
            
            if case .vertical(.bottom) = type {
                delta = -delta
            }
            
            newProgress = currentProgress + delta
        } else {
            var delta = event.delta.y
            
            if progress.isMultipleValues {
                delta = -delta
            }
            
            if case .vertical(.bottom) = type {
                delta = -delta
            }
            
            newProgress = currentProgress + delta / size.height
        }
        
        return newProgress
    }
}

// MARK: - Grid

extension CompactSlider {
    func onScrollWheelGridChange(_ event: ScrollWheelEvent, size: CGSize, isRightToLeft: Bool) {
        if event.isEnded {
            updateGridOnEnd()
            return
        }
        
        let progressX = onScrollWheelHorizontalProgress(
            event,
            size: size,
            type: .grid,
            isRightToLeft: isRightToLeft,
            currentProgress: progress.progresses[0],
            progressStep: step?.pointProgressStep?.x
        ).clamped()
        
        let progressY = onScrollWheelVerticalProgress(
          event,
          size: size,
          type: .grid,
          currentProgress: progress.progresses[1],
          progressStep: step?.pointProgressStep?.y
        ).clamped()
        
        let updatedX = progress.update(progressX, at: 0)
        let updatedY = progress.update(progressY, at: 1)
        
        if (updatedX && (progressX == 1 || progressX == 0))
            || (updatedY && (progressY == 1 || progressY == 0)) {
            HapticFeedback.vibrate(isEnabled: isHapticFeedbackEnabled)
        }
    }
}

// MARK: - Circular Grid

extension CompactSlider {
    func onScrollWheelCircularGridChange(
        _ event: ScrollWheelEvent,
        size: CGSize,
        isRightToLeft: Bool
    ) {
        let maxDistance = size.minValue / 2
        
        guard maxDistance > 0 else { return }
        
        if event.isEnded {
            updateCircularGridOnEnd()
            return
        }
        
        let deltaX = onScrollWheelDeltaX(event, type: .circularGrid, isRightToLeft: isRightToLeft)
        let currentLocation = progress.polarPoint.toCartesian(size: size)
        let origin = CGPoint(x: size.minValue / 2, y: size.minValue / 2)
        
        let newLocation = CGPoint(
            x: currentLocation.x + deltaX,
            y: currentLocation.y + event.delta.y
        )
        
        var angle = newLocation.calculateAngle(from: origin)
        angle = angle < .zero ? .degrees(angle.degrees + 360) : angle
        
        let normalizedRadius = newLocation.calculateDistance(from: origin) / maxDistance
        
        updateCircularGrid(
            polarPoint: .init(angle: angle, normalizedRadius: normalizedRadius),
            maxDistance: maxDistance
        )
    }
}

#if DEBUG
import SwiftUI

struct ScrollWheelPreview: View {
    @State var value = 0.3
    @State var values: [Double] = [0.2, 0.5, 0.7]
    @State var point = CGPoint(x: 50, y: 50)
    @State var pointWithStep = CGPoint(x: 50, y: 50)
    @State var polarPoint: CompactSliderPolarPoint = .zero
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Text("Value: \(value, format: .percent.precision(.fractionLength(1)))")
                Text("Values: \(values.map({ $0.formatted(.percent.precision(.fractionLength(1))) }).joined(separator: " | "))")
            }
            
            Group {
                CompactSlider(value: $value)
                CompactSlider(values: $values)
            }
            .frame(maxHeight: 30)
            
            Divider()
            
            HStack(spacing: 20) {
                Text("Point: \(Int(point.x)) x \(Int(point.y))")
                Text("Point (with step): \(Int(pointWithStep.x)) x \(Int(pointWithStep.y))")
            }
            
            HStack(spacing: 20) {
                CompactSlider(point: $point, in: .zero ... .init(x: 100, y: 100))
                    .frame(width: 150, height: 150)
                CompactSlider(point: $pointWithStep, in: .zero ... .init(x: 100, y: 100), step: .init(x: 10, y: 10))
                    .frame(width: 150, height: 150)
            }
            
            Divider()
            
            Text("Angle: \(Int(polarPoint.angle.degrees))º Radius: \(polarPoint.normalizedRadius, format: .percent.precision(.fractionLength(0)))")
            
            HStack(spacing: 20) {
                CompactSlider(polarPoint: $polarPoint)
                    .frame(width: 150, height: 150)
                
                CompactSlider(
                    polarPoint: $polarPoint,
                    step: .init(angle: .degrees(5), normalizedRadius: 0.05)
                )
                .frame(width: 150, height: 150)
            }
        }
        .monospacedDigit()
    }
}

#Preview("Scroll Wheel") {
    ScrollWheelPreview()
        .padding()
        .frame(width: 400, height: 800, alignment: .top)
}
#endif

#endif
