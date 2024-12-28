// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
#if canImport(AppKit)
import AppKit
import Combine

struct ScrollWheelEvent: Equatable {
    static let zero = ScrollWheelEvent(location: .zero, delta: .zero)
    
    let location: CGPoint
    let delta: CGPoint
    
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
                if let event = $0, let window = event.window {
                    return ScrollWheelEvent(
                        location: CGPoint(
                            x: event.locationInWindow.x,
                            y: window.frame.size.height - event.locationInWindow.y
                        ),
                        delta: CGPoint(x: event.scrollingDeltaX, y: event.scrollingDeltaY)
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
extension View {
    func onScrollWheel(
        isEnabled: Bool = false,
        action: @escaping (_ event: ScrollWheelEvent) -> Void
    ) -> some View {
        self
    }
}
#endif
