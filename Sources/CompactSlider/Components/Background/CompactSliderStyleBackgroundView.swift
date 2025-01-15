// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSliderStyleBackgroundView: View {
    @Environment(\.compactSliderBackgroundView) var backgroundView
    let padding: EdgeInsets
    
    public init(padding: EdgeInsets) {
        self.padding = padding
    }
    
    public var body: some View {
        backgroundView(padding)
    }
}

// MARK: - Environment

struct BackgroundViewKey: EnvironmentKey {
    static var defaultValue: (EdgeInsets) -> AnyView = { padding in
        BackgroundContainerView(padding: padding) {
            DefaultBackgroundView(configuration: $0, padding: $1)
        }
        .anyView()
    }
}

extension EnvironmentValues {
    var compactSliderBackgroundView: (EdgeInsets) -> AnyView {
        get { self[BackgroundViewKey.self] }
        set { self[BackgroundViewKey.self] = newValue }
    }
}

// MARK: - View

extension View {
    public func compactSliderBackground<V: View>(
        @ViewBuilder backgroundView: @escaping (
            _ configuration: CompactSliderStyleConfiguration,
            _ padding: EdgeInsets
        ) -> V
    ) -> some View {
        environment(
            \.compactSliderBackgroundView,
             { padding in
                 BackgroundContainerView(padding: padding) {
                     backgroundView($0, $1)
                 }
                 .anyView()
             }
        )
    }
}
