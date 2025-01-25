// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// The default slider style.
public struct DefaultCompactSliderStyle: CompactSliderStyle {
    #if os(macOS)
    @Environment(\.appearsActive) var appearsActive
    #endif
    
    public let type: CompactSliderType
    public let padding: EdgeInsets
    let clipShapeStyle: ClipShapeStyle
    
    public init(
        type: CompactSliderType = .horizontal(.leading),
        clipShapeStyle: ClipShapeStyle = .roundedRectangle(cornerRadius: Defaults.cornerRadius),
        padding: EdgeInsets = .zero
    ) {
        self.type = type
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
            
            DefaultCompactSliderStyleScaleView(configuration: configuration)
            DefaultCompactSliderStyleHandleView(configuration: configuration)
        }
        .padding(padding)
        .background(CompactSliderStyleBackgroundView(padding: padding))
        .compositingGroup()
        .contentShape(Rectangle())
        .clipShapeStyle(clipShapeStyle)
        .environment(\.compactSliderStyleConfiguration, configuration)
        #if os(macOS)
        .saturation(appearsActive ? 1 : 0)
        #endif
    }
}
