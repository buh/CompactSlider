// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A default compact slider style. Use it to setup the slider type, clip shape style, and padding.
///
/// The default type is horizontal with a leading alignment. The default clip shape style is
/// a rounded rectangle with a corner radius. The default padding is `.zero`.
///
/// You can change the type, clip shape style, and padding by using the `horizontal`, `vertical`,
/// `scrollable`, `grid`, and `circularGrid` static functions.
///
/// Example:
/// ```swift
/// CompactSlider(value: $value, in: 0...100, step: 1)
///    .compactSliderStyle(default: .horizontal(.center, clipShapeStyle: .capsule, padding: .all(10)))
///    .frame(maxHeight: 40)
///    .accentColor(.green)
/// ```
///
/// - SeeAlso: `CompactSliderStyle`.
/// - Note: You can create your own compact slider style by implementing the `CompactSliderStyle` protocol.
public struct DefaultCompactSliderStyle: CompactSliderStyle {
    #if os(macOS)
    @Environment(\.appearsActive) var appearsActive
    #endif
    
    /// The type of the slider.
    public let type: CompactSliderType
    /// The internal padding of the slider from background to handle.
    public let padding: EdgeInsets
    
    private let clipShapeStyle: ClipShapeStyle
    private let clipShapeOptionSet: ClipShapeOptionSet
    
    init(
        type: CompactSliderType = .horizontal(.leading),
        clipShapeStyle: ClipShapeStyle = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        clipShapeOptionSet: ClipShapeOptionSet = .all,
        padding: EdgeInsets = .zero
    ) {
        self.type = type
        self.clipShapeStyle = clipShapeStyle
        self.clipShapeOptionSet = clipShapeOptionSet
        self.padding = padding
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .center) {
            if !configuration.progress.isMultipleValues,
               !configuration.progress.isGridValues,
               !configuration.progress.isCircularGridValues,
               !configuration.type.isScrollable {
                CompactSliderStyleProgressView()
                    .clipShapeStyleIf(
                        !clipShapeOptionSet.contains(.all) && clipShapeOptionSet.contains(.progress),
                        style: clipShapeStyle
                    )
            }
            
            DefaultCompactSliderStyleScaleView(configuration: configuration)
                .clipShapeStyleIf(
                    !clipShapeOptionSet.contains(.all) && clipShapeOptionSet.contains(.scale),
                    style: clipShapeStyle
                )
            
            DefaultCompactSliderStyleHandleView(configuration: configuration)
        }
        .padding(padding)
        .background(
            CompactSliderStyleBackgroundView(padding: padding)
                .clipShapeStyleIf(
                    !clipShapeOptionSet.contains(.all) && clipShapeOptionSet.contains(.background),
                    style: clipShapeStyle
                )
        )
        .compositingGroup()
        .contentShape(clipShapeStyle)
        .clipShapeStyleIf(clipShapeOptionSet.contains(.all), style: clipShapeStyle)
        .environment(\.compactSliderStyleConfiguration, configuration)
        #if os(macOS)
        .saturation(appearsActive ? 1 : 0)
        #endif
    }
}
