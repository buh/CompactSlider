// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSliderStyleHandleView: View {
    @Environment(\.compactSliderHandleView) var handleView
    
    public var body: some View {
        handleView
            .allowsTightening(false)
    }
}

// MARK: - Environment

struct HandleViewKey: EnvironmentKey {
    static var defaultValue: AnyView =
        HandleViewContainerView { _, style, _, _ in
            HandleView(style: style)
        }
        .anyView()
}

extension EnvironmentValues {
    public var compactSliderHandleView: AnyView {
        get { self[HandleViewKey.self] }
        set { self[HandleViewKey.self] = newValue }
    }
}

// MARK: - View

extension View {
    public func compactSliderHandle<V: View>(
        @ViewBuilder handleView: @escaping (
            _ configuration: CompactSliderStyleConfiguration,
            _ handleStyle: HandleStyle,
            _ progress: Double,
            _ index: Int
        ) -> V
    ) -> some View {
        environment(
            \.compactSliderHandleView,
             HandleViewContainerView {
                 handleView($0, $1, $2, $3)
             }
             .anyView()
        )
    }
}
