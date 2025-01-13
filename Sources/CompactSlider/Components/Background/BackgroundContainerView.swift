// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct BackgroundContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    let padding: EdgeInsets
    let backgroundView: (CompactSliderStyleConfiguration, EdgeInsets) -> V
    
    init(
        padding: EdgeInsets,
        backgroundView: @escaping (CompactSliderStyleConfiguration, EdgeInsets) -> V
    ) {
        self.padding = padding
        self.backgroundView = backgroundView
    }
    
    var body: some View {
        backgroundView(configuration, padding)
            .allowsTightening(false)
    }
}
