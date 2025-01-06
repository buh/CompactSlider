// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSliderStyleProgressView: View {
    @Environment(\.compactSliderProgressView) var progressView
    
    public var body: some View {
        progressView
    }
}

// MARK: - Environment

struct ProgressViewKey: EnvironmentKey {
    static var defaultValue: AnyView =
        ProgressContainerView { configuration in
            ProgressView(
                focusState: configuration.focusState,
                fillStyle: Defaults.progressColor,
                focusedFillStyle: Defaults.focusedProgressColor
            )
        }
        .anyView()
}

extension EnvironmentValues {
    var compactSliderProgressView: AnyView {
        get { self[ProgressViewKey.self] }
        set { self[ProgressViewKey.self] = newValue }
    }
}

// MARK: - View

public extension View {
    func compactSliderProgress<V: View>(
        @ViewBuilder progressView: @escaping (_ configuration: CompactSliderStyleConfiguration) -> V
    ) -> some View {
        environment(
            \.compactSliderProgressView,
             ProgressContainerView {
                 progressView($0)
             }
            .anyView()
        )
    }
}
