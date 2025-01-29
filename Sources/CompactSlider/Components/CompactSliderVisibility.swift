// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

/// A scale visibility determines the rules for showing a component.
public enum CompactSliderVisibility {
    case focused, always, hidden
    
    /// Default the handle visibility.
    public static var `default`: CompactSliderVisibility {
        #if os(macOS)
        .focused
        #else
        .always
        #endif
    }
}
