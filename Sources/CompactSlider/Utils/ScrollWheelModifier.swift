// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import Combine

struct ScrollWheelEvent: Equatable {
    static let zero = ScrollWheelEvent(location: .zero, delta: .zero, isEnded: true)
    
    let location: CGPoint
    let delta: CGPoint
    let isEnded: Bool
    
    var isHorizontalDelta: Bool {
        abs(delta.x) > abs(delta.y)
    }
}

struct ScrollWheelModifier: ViewModifier {
    let action: (_ event: ScrollWheelEvent) -> Void
    private var cancellable = Set<AnyCancellable>()
    
    init(action: @escaping (_ event: ScrollWheelEvent) -> Void) {
        self.action = action
        subscribeForScrollWheelEvents()
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    mutating func subscribeForScrollWheelEvents() {
        NSApp.publisher(for: \.currentEvent)
            .filter { $0?.type == .scrollWheel }
            .compactMap {
                if let event = $0,
                   let window = event.window,
                   (event.phase == .changed || event.phase == .ended) {
                    return ScrollWheelEvent(
                        location: CGPoint(
                            x: event.locationInWindow.x,
                            y: window.frame.size.height - event.locationInWindow.y
                        ),
                        delta: CGPoint(x: event.scrollingDeltaX, y: event.scrollingDeltaY),
                        isEnded: event.phase == .ended
                    )
                }
                
                return nil
            }
            .removeDuplicates()
            .sink { [action] in action($0) }
            .store(in: &cancellable)
    }
}

extension View {
    @ViewBuilder
    func onScrollWheel(
        isEnabled: Bool = true,
        action: @escaping (_ event: ScrollWheelEvent) -> Void
    ) -> some View {
        if isEnabled {
            modifier(ScrollWheelModifier(action: action))
        } else {
            self
        }
    }
}
#else
struct ScrollWheelEvent: Equatable {
    static let zero = ScrollWheelEvent()
}

extension View {
    func onScrollWheel(
        isEnabled: Bool = false,
        action: @escaping (_ event: ScrollWheelEvent) -> Void
    ) -> some View {
        self
    }
}
#endif
