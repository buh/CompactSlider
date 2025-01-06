// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct ContentView: View {

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
            
            InsideFormView()
                .tabItem {
                    Label("Form", systemImage: "rectangle.and.pencil.and.ellipsis.rtl")
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

#Preview {
    ContentView()
}
