// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSliderStyleBackgroundView: View {
    @Environment(\.compactSliderBackgroundView) var backgroundView
    
    public var body: some View {
        backgroundView
    }
}

// MARK: - Environment

struct BackgroundViewKey: EnvironmentKey {
    static var defaultValue: AnyView =
        BackgroundContainerView { _ in
            Defaults.label.opacity(Defaults.backgroundOpacity)
        }
        .anyView()
}

extension EnvironmentValues {
    var compactSliderBackgroundView: AnyView {
        get { self[BackgroundViewKey.self] }
        set { self[BackgroundViewKey.self] = newValue }
    }
}

// MARK: - View

public extension View {
    func compactSliderBackground<V: View>(
        @ViewBuilder backgroundView: @escaping (_ progress: Progress) -> V
    ) -> some View {
        environment(
            \.compactSliderBackgroundView,
             BackgroundContainerView {
                 backgroundView($0)
             }
             .anyView()
        )
    }
}
