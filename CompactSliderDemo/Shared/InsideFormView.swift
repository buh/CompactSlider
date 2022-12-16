// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct InsideFormView: View {

    @State private var defaultValue: Double = 0.5
    @State private var lowerValue: Double = 0.4
    @State private var upperValue: Double = 0.6

    var body: some View {
        Form {
            if #available(iOS 15.0, watchOSApplicationExtension 8.0, *) {
                Section("Single Value") {
                    Text("A default single value slider.")
                    CompactSlider(value: $defaultValue) {
                        Spacer()
                        Text(String(format: "%.2f", defaultValue))
                            .monospacedDigitIfPossible()
                    }
                }

                Section("Range Values") {
                    Text("A simple example for range values.")
                    CompactSlider(from: $lowerValue, to: $upperValue) {
                        Text("Range")
                        Spacer()
                        Text(String(format: "%.2f - %.2f", lowerValue, upperValue))
                            .monospacedDigitIfPossible()
                    }
                }
            } else {
                Text("Available on iOS 15.0+")
            }
        }
    }
}

struct InsideFormView_Previews: PreviewProvider {
    static var previews: some View {
        InsideFormView()
    }
}
