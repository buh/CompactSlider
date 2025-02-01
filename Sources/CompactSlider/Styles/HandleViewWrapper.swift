// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct HandleViewWrapper: View {
    @Environment(\.handleStyle) var environmentHandleStyle
    var handleStyle: HandleStyle { environmentHandleStyle.byType(configuration.type) }
    let configuration: CompactSliderStyleConfiguration
    
    var body: some View {
        if configuration.isHandleVisible(handleStyle: handleStyle) {
            if configuration.progress.isMultipleValues, configuration.progress.progresses.count == 0 {
                Rectangle().fill(Color.clear)
            } else {
                CompactSliderStyleHandleView()
            }
        }
    }
}
