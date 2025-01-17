//
//  CompactSliderSystemDemo.swift
//  Demo
//
//  Created by Aleksei Bukhtin on 17-01-2025.
//

import SwiftUI
import CompactSlider

struct CompactSliderSystemDemo: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var layoutDirection: LayoutDirection = .leftToRight
    @State private var progress: Double = 0.3
    
    var body: some View {
        VStack(spacing: 16) {
            Slider(value:  $progress) {
                Text("Progress")
            }
            
            HStack {
                Text("Progress")
                CompactSlider(value: $progress)
                    .compactSliderStyle(default: .horizontal(
                        handleStyle: .circle(visibility: .always, color: .gray, radius: 10),
                        scaleStyle: .centered(
                            line: .init(length: 3, thickness: 3),
                            secondaryLine: nil
                        )
                    ))
                    .compactSliderBackground { _, _ in
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(maxHeight: 5)
                    }
                    .compactSliderProgress { _ in
                        Capsule()
                            .fill(Color.accentColor)
                            .frame(maxHeight: 5)
                    }
                    .frame(maxHeight: 20)
            }
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
