// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSliderStyleScaleView: View {
    @Environment(\.compactSliderScaleView) var scaleView
    
    public var body: some View {
        scaleView
    }
}

// MARK: - Environment

struct ScaleViewKey: EnvironmentKey {
    static var defaultValue: AnyView =
        ScaleContainerView {
            DefaultScaleView(configuration: $0, style: $1)
        }
        .anyView()
}

extension EnvironmentValues {
    var compactSliderScaleView: AnyView {
        get { self[ScaleViewKey.self] }
        set { self[ScaleViewKey.self] = newValue }
    }
}

// MARK: - View

extension View {
    public func compactSliderScale<V: View>(
        @ViewBuilder scaleView: @escaping (
            _ configuration: CompactSliderStyleConfiguration,
            _ style: ScaleStyle
        ) -> V
    ) -> some View {
        environment(
            \.compactSliderScaleView,
             ScaleContainerView {
                 scaleView($0, $1)
             }
             .anyView()
        )
    }
}
