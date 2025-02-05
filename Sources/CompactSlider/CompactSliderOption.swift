// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A set of options for the `CompactSlider`. The options are used to configure the slider behavior.
public enum CompactSliderOption: Hashable {
    /// Enable haptic feedback. Enabled by default.
    case enabledHapticFeedback
    /// The minimum distance a drag gesture must move before it's considered a drag.
    /// Default value is 1 and 0 for macOS.
    case dragGestureMinimumDistance(CGFloat)
    /// Attaches a high priority gesture to the slider.
    case highPriorityGesture
    /// Delays the touch gesture. Enabled by default for iOS.
    /// It's useful for sliders in a scroll view or forms.
    case delayedGesture
    /// The slider can be scrolled with a scroll wheel.
    case scrollWheel
    /// The slider can be scrolled with a snap to each step.
    case snapToSteps
    /// Removes the background.
    case withoutBackground
    /// Allows the slider to loop values.
    case loopValues
    /// Allows the slider to expand the background and progress view when focused.
    case expandOnFocus(minScale: CGFloat)
}

/// A set of drag gesture options: minimum drag distance, delayed touch, and high priority.
extension Set<CompactSliderOption> {
    /// Defines the default options for the slider.
    ///
    /// - For iOS: minimum drag distance 1 with touch delay and enabled haptic feedback.
    /// - For macOS: minimum drag distance 0 with enabled haptic feedback
    public static var `default`: Self {
        #if os(macOS) || os(visionOS)
        [.enabledHapticFeedback, .dragGestureMinimumDistance(0)]
        #else
        [.enabledHapticFeedback, .dragGestureMinimumDistance(1), .delayedGesture]
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
    
    var expandOnFocusMinScale: CGFloat? {
        for option in self {
            if case .expandOnFocus(let value) = option {
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

// MARK: - Environment

struct CompactSliderOptionKey: EnvironmentKey {
    static var defaultValue: Set<CompactSliderOption> = .default
}

extension EnvironmentValues {
    /// The environment value for the compact slider options.
    public var compactSliderOptions: Set<CompactSliderOption> {
        get { self[CompactSliderOptionKey.self] }
        set { self[CompactSliderOptionKey.self] = newValue }
    }
}

extension View {
    /// Sets the slider options.
    public func compactSliderOptions(_ options: CompactSliderOption...) -> some View {
        environment(\.compactSliderOptions, Set(options))
    }
    
    /// Adds slider options to the existing ones.
    public func compactSliderOptionsByAdding(_ options: CompactSliderOption...) -> some View {
        modifier(CompactSliderOptionsModifier(addOptions: options))
    }
    
    /// Removes slider options from the existing ones.
    public func compactSliderOptionsByRemoving(_ options: CompactSliderOption...) -> some View {
        modifier(CompactSliderOptionsModifier(removeOptions: options))
    }
}

struct CompactSliderOptionsModifier: ViewModifier {
    @Environment(\.compactSliderOptions) var compactSliderOptions
    
    var addOptions: [CompactSliderOption] = []
    var removeOptions: [CompactSliderOption] = []
    
    func body(content: Content) -> some View {
        if addOptions.isEmpty {
            content.environment(\.compactSliderOptions, compactSliderOptions.subtracting(removeOptions))
        } else {
            content.environment(\.compactSliderOptions, compactSliderOptions.union(addOptions))
        }
    }
}
