// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public enum CompactSliderOption: Hashable {
    /// Creates a dragging gesture with the minimum dragging distance before the gesture succeeds.
    /// Default values 1 and 0 for iOS and macOS respectively.
    case dragGestureMinimumDistance(CGFloat)
    /// Attaches a gesture to the slider with a higher precedence than gestures defined by the view.
    case highPriorityGesture
    /// Enables delay when sliders inside ``ScrollView`` or ``Form``. Enabled by default for iOS.
    case delayedGesture
    /// Enables the scroll wheel.
    case scrollWheel
    /// Enables the snapping on steps.
    case snapToSteps
}

/// A set of drag gesture options: minimum drag distance, delayed touch, and high priority.
extension Set<CompactSliderOption> {
    /// Default values for the drag gesture.
    /// For iOS: minimum drag distance 1 with touch delay.
    /// For macOS: minimum drag distance 0.
    public static var `default`: Self {
        #if os(macOS)
        [.dragGestureMinimumDistance(0), .scrollWheel]
        #else
        [.dragGestureMinimumDistance(1), .delayedGesture]
        #endif
    }
    
    var dragGestureMinimumDistanceValue: CGFloat {
        for option in self {
            if case .dragGestureMinimumDistance(let value) = option {
                return value
            }
        }
        
        return 1
    }
}

// MARK: - View Extension

extension View {
    @ViewBuilder
    func dragGesture(
        options: Set<CompactSliderOption>,
        onChanged: @escaping (DragGesture.Value) -> Void,
        onEnded: @escaping (DragGesture.Value) -> Void
    ) -> some View {
        delayedGesture(options: options)
            .prioritizedGesture(
                DragGesture(minimumDistance: options.dragGestureMinimumDistanceValue)
                    .onChanged(onChanged)
                    .onEnded(onEnded),
                options: options
            )
    }
    
    @ViewBuilder
    private func delayedGesture(options: Set<CompactSliderOption>) -> some View {
        if options.contains(.delayedGesture) {
            onTapGesture {}
        } else {
            self
        }
    }
    
    @ViewBuilder
    private func prioritizedGesture<T: Gesture>(_ gesture: T, options: Set<CompactSliderOption>) -> some View {
        if options.contains(.highPriorityGesture) {
            highPriorityGesture(gesture)
        } else {
            self.gesture(gesture)
        }
    }
}
