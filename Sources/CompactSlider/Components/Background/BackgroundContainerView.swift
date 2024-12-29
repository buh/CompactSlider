// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct BackgroundContainerView<V: View>: View {
    @Environment(\.compactSliderStyleConfiguration) var configuration
    let backgroundView: (Progress) -> V
    
    init(backgroundView: @escaping (Progress) -> V) {
        self.backgroundView = backgroundView
    }
    
    var body: some View {
        backgroundView(configuration.progress)
            .allowsTightening(false)
    }
}
