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
    /// The type of the slider.
    public let type: CompactSliderType
    /// The internal padding of the slider from background to handle.
    public let padding: EdgeInsets
    private let clipShapeStyle: ClipShapeStyle
    
    init(
        type: CompactSliderType = .horizontal(.leading),
        clipShapeStyle: ClipShapeStyle = .default(for: .horizontal(.leading)),
        padding: EdgeInsets = .zero
    ) {
        self.type = type
        self.clipShapeStyle = clipShapeStyle
        self.padding = padding
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if !configuration.progress.isMultipleValues,
               !configuration.progress.isGridValues,
               !configuration.progress.isCircularGridValues,
               !configuration.type.isScrollable {
                ProgressViewWrapper(configuration: configuration)
                    .clipShapeStyleIf(
                        !clipShapeStyle.options.contains(.all) && clipShapeStyle.options.contains(.progress),
                        shape: clipShapeStyle.shape
                    )
            }
            
            ScaleViewWrapper(configuration: configuration)
                .clipShapeStyleIf(
                    !clipShapeStyle.options.contains(.all) && clipShapeStyle.options.contains(.scale),
                    shape: clipShapeStyle.shape
                )
            
            HandleViewWrapper(configuration: configuration)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(padding)
        .background(
            BackgroundViewWrapper(configuration: configuration, padding: padding)
                .clipShapeStyleIf(
                    !clipShapeStyle.options.contains(.all) && clipShapeStyle.options.contains(.background),
                    shape: clipShapeStyle.shape
                )
        )
        .compositingGroup()
        .contentShape(clipShapeStyle.shape)
        .clipShapeStyleIf(clipShapeStyle.options.contains(.all), shape: clipShapeStyle.shape)
        .environment(\.compactSliderStyleConfiguration, configuration)
    }
}
