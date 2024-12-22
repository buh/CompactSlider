// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressView: View {
    @Environment(\.compactSliderSecondaryAppearance) var secondaryAppearance
    let configuration: CompactSliderStyleConfiguration
    
    var body: some View {
        let size = configuration.progressSize()
        let offset = configuration.progressOffset()
        
        Rectangle()
            .fill(configuration.isFocused ? secondaryAppearance.focusedProgressFillStyle : secondaryAppearance.progressFillStyle)
            .frame(width: size.width, height: size.height)
            .offset(x: offset.x, y: offset.y)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
