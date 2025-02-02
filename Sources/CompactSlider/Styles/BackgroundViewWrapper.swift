// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct BackgroundViewWrapper: View {
    @Environment(\.compactSliderOptions) var sliderOptions
    @Environment(\.compactSliderBackgroundView) var backgroundView
    let padding: EdgeInsets
    
    init(padding: EdgeInsets = .zero) {
        self.padding = padding
    }
    
    var body: some View {
        if !sliderOptions.contains(.withoutBackground) {
            backgroundView(padding)
        }
    }
}
