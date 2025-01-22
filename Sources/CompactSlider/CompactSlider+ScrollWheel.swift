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
        
        return newProgress
    }
}

// MARK: - Grid

extension CompactSlider {
    func onScrollWheelGridChange(_ event: ScrollWheelEvent, size: CGSize, isRightToLeft: Bool) {
        if event.isEnded {
            if !options.contains(.snapToSteps), let step = step?.pointProgressStep {
                progress.updatePoint(rounded: step)
                HapticFeedback.vibrate(isEnabled: isHapticFeedbackEnabled)
            }
            
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
        let maxDistance = CGPoint(x: size.minValue / 2, y: size.minValue / 2).calculateDistance()
        
        guard maxDistance > 0 else { return }
        
        if event.isEnded {
            if !options.contains(.snapToSteps), let step = step?.polarPointProgressStep {
                progress.updatePolarPoint(progress.polarPoint.rounded(step))
                HapticFeedback.vibrate(isEnabled: isHapticFeedbackEnabled)
            }
            
            return
        }
        
        let deltaX = onScrollWheelDeltaX(
            event,
            type: .circularGrid,
            isRightToLeft: isRightToLeft
        )
        
        let polarPoint = progress.polarPoint
        let currentPolarPointLocation = progress.polarPoint.toCartesian(size: size)
        
        let location = CGPoint(
            x: deltaX + currentPolarPointLocation.x,
            y: event.delta.y + currentPolarPointLocation.y
        )
        
        print(currentPolarPointLocation, location, maxDistance)

        let normalizedRadius = location.calculateDistance(from: .init(x: size.width / 2, y: size.width / 2)) / maxDistance
        
        print(polarPoint, location.calculateAngle())

        var angle = location.calculateAngle()
        angle = angle < .zero ? .degrees(angle.degrees + 360) : angle
        
        
        print("updated", location, angle, normalizedRadius)
        
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
