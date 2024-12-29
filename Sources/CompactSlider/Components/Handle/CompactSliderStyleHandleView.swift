// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSliderStyleHandleView: View {
    @Environment(\.compactSliderHandleView) var handleView
    
    public var body: some View {
        handleView
    }
}

// MARK: - Environment

struct HandleViewKey: EnvironmentKey {
    static var defaultValue: AnyView =
        HandleViewContainerView {
            HandleView(style: $0, progress: $1, index: $2)
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
    func compactSliderHandleViewKey<V: View>(
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
