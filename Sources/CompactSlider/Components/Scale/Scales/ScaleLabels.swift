// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public enum ScaleLabelsVisibility: Hashable {
    case always
    case hideNearCurrentValue(threshold: Double)
}

struct ScaleLabels: View {
    @Environment(\.compactSliderOptions) var compactSliderOptions
    let configuration: CompactSliderStyleConfiguration
    var visibility: ScaleLabelsVisibility = .always
    let axis: Axis
    let alignment: Alignment
    var color: Color = Color.secondary
    var offset: CGPoint = .zero
    let labels: [Double: String]
    
    var body: some View {
        ZStack {
            ForEach(Array(labels.keys), id: \.self) { progress in
                Text(labels[progress] ?? "")
                    .offset(
                        x: axis == .horizontal
                            ? configuration.size.width * progress - configuration.size.width / 2 + offset.x
                            : 0,
                        y: axis == .vertical
                            ? configuration.size.height * progress - configuration.size.width / 2 + offset.y
                            : 0
                    )
                    .opacity(isHidden(for: progress) ? 0 : 1)
            }
            .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    private func isHidden(for progress: Double) -> Bool {
        guard case .hideNearCurrentValue(let threshold) = visibility else { return false }
        
        let t = threshold.clamped()
        
        for currentProgress in configuration.progress.progresses {
            let isNearProgress = abs(currentProgress - progress) < t
            var isNearLoopProgress = false
            
            if compactSliderOptions.contains(.loopValues) {
                isNearLoopProgress = abs((1 - currentProgress) - progress) < t
            }
            
            if isNearProgress || isNearLoopProgress {
                return true
            }
        }
        
        return false
    }
}

#Preview {
    ScaleLabels(
        configuration: .preview(size: CGSize(width: 100, height: 100)),
        axis: .horizontal,
        alignment: .top,
        labels: [0: "0", 0.5: "50%", 1: "100%"]
    )
    .frame(width: 150, height: 150)
    .border(.blue)
    .padding()
}
