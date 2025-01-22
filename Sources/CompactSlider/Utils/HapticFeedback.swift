// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum HapticFeedback {
    #if os(iOS)
    private static let feedbackGenerator: UISelectionFeedbackGenerator = {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        return generator
    }()
    #endif
    
    static func vibrate(isEnabled: Bool) {
        guard isEnabled else { return }
        
        #if os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
        #elseif os(iOS)
        feedbackGenerator.selectionChanged()
        feedbackGenerator.prepare()
        #endif
    }
}
