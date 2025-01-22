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
            #if os(macOS)
            macOS()
            #else
            iOS()
            #endif
        }
        .padding()
    }
    
    @ViewBuilder
    func macOS() -> some View {
        Slider(value:  $progress) {
            Text("Progress")
        }
        
        HStack {
            Text("Progress")
            CompactSlider(value: $progress)
                .compactSliderStyle(default: .horizontal(
                    handleStyle: .circle(visibility: .always, radius: 10),
                    scaleStyle: nil,
                    clipShapeType: .none
                ))
                .compactSliderBackground { _, _ in
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(maxHeight: 4)
                }
                .compactSliderProgress { _ in
                    Capsule()
                        .fill(Color.accentColor)
                        .frame(maxHeight: 4)
                }
                .compactSliderHandle { config, handleStyle, _, _ in
                    HandleView(
                        style: .circle(
                            color: config.colorScheme == .light ? .white : .gray
                        )
                    )
                    .shadow(radius: 1, y: 0.5)
                }
                .frame(maxHeight: 20)
        }
    }
    
    @ViewBuilder
    func iOS() -> some View {
        Slider(value:  $progress) {
            Text("Progress")
        }
        
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .horizontal(
                handleStyle: .circle(visibility: .always, radius: 13.5),
                scaleStyle: nil,
                clipShapeType: .none
            ))
            .compactSliderBackground { _, _ in
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxHeight: 4)
            }
            .compactSliderProgress { _ in
                Capsule()
                    .fill(Color.accentColor)
                    .frame(maxHeight: 4)
            }
            .compactSliderHandle { config, handleStyle, _, _ in
                HandleView(
                    style: .circle(
                        color: config.colorScheme == .light ? .white : .gray
                    )
                )
                .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
            }
            .frame(maxHeight: 27)
    }
}

#Preview("System Slider") {
    CompactSliderSystemDemo()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
