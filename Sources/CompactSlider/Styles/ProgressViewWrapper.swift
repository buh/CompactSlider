// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressViewWrapper: View {
    @Environment(\.compactSliderOptions) var sliderOptions
    @Environment(\.compactSliderProgressView) var progressView
    let configuration: CompactSliderStyleConfiguration
    
    public var body: some View {
        if configuration.type.isLinear,
           let expandOnFocusMinScale = sliderOptions.expandOnFocusMinScale {
            let maxValue = configuration.frameMaxValue(expandOnFocusMinScale)
            progressView
                .frame(maxWidth: maxValue?.width, maxHeight: maxValue?.height)
        } else {
            progressView
        }
    }
}
