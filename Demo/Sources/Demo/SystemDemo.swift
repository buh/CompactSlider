// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct CompactSliderSystemDemo: View {
    @State private var progress: Double = 0.3
    
    var body: some View {
        VStack(spacing: 16) {
            Slider(value:  $progress) {
                Text("Progress")
            }
            
            Text("\"System\" Progress")
            SystemSlider(value: $progress)
            
            Text("Vertical \"System\" Progress")
            SystemSlider(value: $progress)
                .systemSliderStyle(.vertical())
                .frame(maxHeight: 250)
        }
        .padding()
    }
}

#Preview("System Slider") {
    CompactSliderSystemDemo()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
