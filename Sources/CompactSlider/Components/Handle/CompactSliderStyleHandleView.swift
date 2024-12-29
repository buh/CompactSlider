// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
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
        HandleViewContainerView { style, _, _ in
            HandleView(style: style)
        }
        .anyView()
}

extension EnvironmentValues {
    var compactSliderHandleView: AnyView {
        get { self[HandleViewKey.self] }
        set { self[HandleViewKey.self] = newValue }
    }
}

// MARK: - View

public extension View {
    func compactSliderHandleView<V: View>(
        @ViewBuilder handleView: @escaping (_ handleStyle: HandleStyle, _ progress: Double, _ index: Int) -> V
    ) -> some View {
        environment(
            \.compactSliderHandleView,
             HandleViewContainerView {
                 handleView($0, $1, $2)
             }
             .anyView()
        )
    }
}
