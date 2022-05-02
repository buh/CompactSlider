// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct ContentView: View {
    
    @State private var defaultValue: Double = 0.5
    @State private var defaultValue2: Double = 0.0
    @State private var stepValue: Double = 50
    @State private var lowerValue: Double = 0.4
    @State private var upperValue: Double = 0.6
    @State private var sliderState: CompactSliderState = .zero
    @State private var sliderState2: CompactSliderState = .zero

    var body: some View {
        TabView {
            SingleValueView()
                .tabItem {
                    Label("Single Value", systemImage: "rectangle.lefthalf.filled")
                }
            RangeValuesView()
                .tabItem {
                    Label("Range Values", systemImage: "rectangle.split.3x1.fill")
                }
            AdvancedView()
                .tabItem {
                    Label("Advanced", systemImage: "capsule.lefthalf.filled")
                }
        }
        .navigationTitle("CompactSlider")
        #if os(macOS)
        .padding()
        .frame(width: 600, height: 500)
        #endif
    }
}

private extension Double {
    var formatted: String { String(format: "%.2f", self) }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
