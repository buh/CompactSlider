// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// The default slider style.
public struct DefaultCompactSliderStyle: CompactSliderStyle {
    @Environment(\.handleStyle) var handleStyle
    #if os(macOS)
    @Environment(\.appearsActive) var appearsActive
    #endif
    
    public let type: CompactSliderType
    public let padding: EdgeInsets
    
    let scaleStyle: ScaleStyle?
    let clipShapeStyle: ClipShapeType
    
    public init(
        type: CompactSliderType = .horizontal(.leading),
        scaleStyle: ScaleStyle? = .atSide(),
        clipShapeStyle: ClipShapeType = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) {
        self.type = type
        self.scaleStyle = scaleStyle
        self.clipShapeStyle = clipShapeStyle
        self.padding = padding
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .center) {
            if !configuration.progress.isMultipleValues,
               !configuration.progress.isGridValues,
               !configuration.progress.isCircularGridValues,
               !configuration.type.isScrollable {
                CompactSliderStyleProgressView()
            }
            
            if !configuration.progress.isGridValues,
               let scaleStyle,
               configuration.isScaleVisible(scaleStyle: scaleStyle) {
                CompactSliderStyleScaleView()
            }
            
            DefaultCompactSliderStyleHandleView(configuration: configuration)
        }
        .padding(padding)
        .background(CompactSliderStyleBackgroundView(padding: padding))
        .compositingGroup()
        .contentShape(Rectangle())
        .clipShapeStyle(clipShapeStyle)
        .environment(\.compactSliderStyleConfiguration, configuration)
        .environment(\.scaleStyle, scaleStyle)
        #if os(macOS)
        .saturation(appearsActive ? 1 : 0)
        #endif
    }
}
