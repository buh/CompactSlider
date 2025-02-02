// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension Shape {
    func fillUltraThinMaterial(inverted: Bool = false) -> some View {
        #if os(macOS) || os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
        fill(.ultraThinMaterial, style: .init(eoFill: inverted))
        #else
        if #available(watchOS 10.0, *) {
            return fill(.ultraThinMaterial, style: .init(eoFill: inverted))
        }
        
        return fill(Defaults.backgroundColor.opacity(0.3), style: .init(eoFill: inverted))
        #endif
    }
}
