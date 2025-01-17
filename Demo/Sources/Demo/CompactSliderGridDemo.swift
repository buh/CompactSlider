// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct CompactSliderGridDemo: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var layoutDirection: LayoutDirection = .leftToRight
    @State private var point = CGPoint(x: 50, y: 50)
    @State private var snappedPoint = CGPoint(x: 50, y: 50)
    
    var body: some View {
        VStack(spacing: 16) {
            Picker(selection: $layoutDirection) {
                Text("Left-to-Right").tag(LayoutDirection.leftToRight)
                Text("Right-to-Left").tag(LayoutDirection.rightToLeft)
            } label: { EmptyView() }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                Spacer()
                
                Text("\(Int(point.x)) x \(Int(point.y))")
                Text("\(Int(snappedPoint.x)) x \(Int(snappedPoint.y))")
                
                Spacer()
            }
            .monospacedDigit()
            
            Divider()
            
            gridSliders()
        }
        .padding()
        .accentColor(.purple)
        .environment(\.layoutDirection, layoutDirection)
    }
    
    @ViewBuilder
    func gridSliders() -> some View {
        CompactSlider(
            point: $point,
            in: CGPoint(x: 0, y: 0) ... CGPoint(x: 100, y: 100)
        )
        .frame(width: 100, height: 100)
        
        HStack {
            CompactSlider(
                point: $point,
                in: CGPoint(x: 0, y: 0) ... CGPoint(x: 100, y: 100),
                step: CGPoint(x: 10, y: 10)
            )
            .frame(width: 100, height: 100)

            CompactSlider(
                point: $snappedPoint,
                in: CGPoint(x: 0, y: 0) ... CGPoint(x: 100, y: 100),
                step: CGPoint(x: 10, y: 10)
            )
            .compactSliderStyle(default: .grid(
                handleStyle: .circle(lineWidth: 2)
            ))
            .frame(width: 100, height: 100)
        }
        
        HStack {
            CompactSlider(
                point: $snappedPoint,
                in: CGPoint(x: 0, y: 0) ... CGPoint(x: 100, y: 100),
                step: CGPoint(x: 10, y: 10)
            )
            .compactSliderBackground {
                GridBackgroundView(
                    configuration: $0,
                    padding: $1,
                    gridSize: 5, invertedGrid: false,
                    gridFill: Color.accentColor.opacity(0.5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Defaults.gridCornerRadius)
                        .stroke(
                            colorScheme == .dark ? Color.white.opacity(0.03) : .black.opacity(0.03),
                            lineWidth: 2
                        )
                        .padding(1)
                )
            }
            .frame(width: 100, height: 100)
            
            CompactSlider(
                point: $snappedPoint,
                in: CGPoint(x: 0, y: 0) ... CGPoint(x: 100, y: 100),
                step: CGPoint(x: 10, y: 10)
            )
            .compactSliderBackground { configuration, padding in
                if #available(macOS 15.0, iOS 18, *) {
                    GridBackgroundView(
                        configuration: configuration,
                        padding: padding,
                        backgroundFill: Color.white.opacity(0.5),
                        handleColor: .white,
                        guidelineColor: .white,
                        normalizedBacklightRadius: 0,
                        gridSize: 2.5,
                        gridFill: MeshGradient(width: 2, height: 2, points: [
                            [0, 0], [1, 0],
                            [0, 1], [1, 1]
                        ], colors: [
                            Color(red: 0.7765, green: 0.7961, blue: 0.7725),
                            Color(red: 0.8431, green: 0.3529, blue: 0.3725),
                            Color(red: 0.1020, green: 0.1647, blue: 0.1804),
                            Color(red: 0.0627, green: 0.1451, blue: 0.1529)
                        ])
                    )
                } else {
                    GridBackgroundView(
                        configuration: configuration,
                        padding: padding,
                        backgroundColor: .white.opacity(0.6),
                        handleColor: .white,
                        guidelineColor: .white,
                        normalizedBacklightRadius: 0,
                        gridSize: 2.5,
                        gridFill: LinearGradient(
                            colors: [
                                Color(red: 0.1020, green: 0.1647, blue: 0.1804),
                                Color(red: 0.3294, green: 0.4471, blue: 0.4235),
                                Color(red: 0.8431, green: 0.3529, blue: 0.3725)
                            ],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                }
            }
            .frame(width: 100, height: 100)
            .accentColor(.white)
            .padding(20)
            .background(Color.black)
        }
    }
}

#Preview("Grid") {
    CompactSliderGridDemo()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
