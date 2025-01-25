// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct DefaultCompactSliderStyleScaleView: View {
    @Environment(\.scaleView) var scaleView
    let configuration: CompactSliderStyleConfiguration
    
    var body: some View {
        if !configuration.progress.isGridValues, let scaleView {
            scaleView
        }
    }
}
