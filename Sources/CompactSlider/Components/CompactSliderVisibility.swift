// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

/// Compact slider components visibility.
public enum CompactSliderVisibility {
    case focused, always, hidden
    
    /// The default visibility.
    public static var `default`: CompactSliderVisibility {
        #if os(macOS)
        .focused
        #else
        .always
        #endif
    }
}
