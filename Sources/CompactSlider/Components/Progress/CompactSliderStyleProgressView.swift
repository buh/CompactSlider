// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
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
        ProgressContainerView { _, focusState in
            ProgressView(
                focusState: focusState,
                fillStyle: Defaults.label.opacity(Defaults.progressOpacity),
                focusedFillStyle: Defaults.label.opacity(Defaults.focusedProgressOpacity)
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
    func compactSliderProgressView<V: View>(
        @ViewBuilder progressView: @escaping (_ progress: Progress, _ focusState: CompactSliderStyleConfiguration.FocusState) -> V
    ) -> some View {
        environment(
            \.compactSliderProgressView,
             ProgressContainerView { progress, focusState in
                 progressView(progress, focusState)
             }
            .anyView()
        )
    }
}
