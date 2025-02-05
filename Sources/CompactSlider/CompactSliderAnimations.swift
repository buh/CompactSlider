// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// Compact slider animations events.
public enum CompactSliderAnimationEvent {
    case hovering
    case dragging
}

// MARK: - Environment

struct CompactSliderAnimationsKey: EnvironmentKey {
    static var defaultValue: [CompactSliderAnimationEvent: Animation] = [:]
}

extension EnvironmentValues {
    /// The environment value for the compact slider options.
    var compactSliderAnimations: [CompactSliderAnimationEvent: Animation] {
        get { self[CompactSliderAnimationsKey.self] }
        set { self[CompactSliderAnimationsKey.self] = newValue }
    }
}

extension View {
    /// Sets the slider animations.
    public func compactSliderAnimation(_ animation: Animation?, when event: CompactSliderAnimationEvent) -> some View {
        modifier(CompactSliderAnimationsModifier(animation: animation, event: event))
    }
}
    

struct CompactSliderAnimationsModifier: ViewModifier {
    @Environment(\.compactSliderAnimations) var animations
    
    var animation: Animation?
    var event: CompactSliderAnimationEvent
    
    func body(content: Content) -> some View {
        content.environment(
            \.compactSliderAnimations,
             {
                 var animations = animations
                 animations[event] = animation
                 return animations
             }()
        )
    }
}
