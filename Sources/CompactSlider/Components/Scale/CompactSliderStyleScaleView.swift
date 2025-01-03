// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
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
            ScaleView(style: $0, alignment: $1, steps: $2)
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

public extension View {
    func compactSliderScale<V: View>(
        @ViewBuilder scaleView: @escaping (_ style: ScaleStyle, _ alignment: Axis, _ steps: Int) -> V
    ) -> some View {
        environment(
            \.compactSliderScaleView,
             ScaleContainerView {
                 scaleView($0, $1, $2)
             }
             .anyView()
        )
    }
}
