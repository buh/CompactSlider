// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct BackgroundViewWrapper: View {
    @Environment(\.compactSliderOptions) var sliderOptions
    @Environment(\.compactSliderBackgroundView) var backgroundView
    let configuration: CompactSliderStyleConfiguration
    let padding: EdgeInsets
    
    init(configuration: CompactSliderStyleConfiguration, padding: EdgeInsets = .zero) {
        self.configuration = configuration
        self.padding = padding
    }
    
    var body: some View {
        if !sliderOptions.contains(.withoutBackground) {
            if configuration.type.isLinear,
               let expandOnFocusMinScale = sliderOptions.expandOnFocusMinScale {
                let maxValue = configuration.frameMaxValue(expandOnFocusMinScale)
                backgroundView(padding)
                    .frame(maxWidth: maxValue?.width, maxHeight: maxValue?.height)
            } else {
                backgroundView(padding)
            }
        }
    }
}
