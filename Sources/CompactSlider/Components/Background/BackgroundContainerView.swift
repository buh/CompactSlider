// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct BackgroundContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    let backgroundView: (CompactSliderStyleConfiguration) -> V
    
    init(backgroundView: @escaping (CompactSliderStyleConfiguration) -> V) {
        self.backgroundView = backgroundView
    }
    
    var body: some View {
        backgroundView(configuration)
            .allowsTightening(false)
    }
}
