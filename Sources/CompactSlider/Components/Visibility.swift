// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

/// A scale visibility determines the rules for showing a component.
public enum Visibility {
    case hoveringOrDragging, always, hidden
    
    /// Default the handle visibility.
    public static var handleDefault: Visibility {
        #if os(macOS)
        .hoveringOrDragging
        #else
        .always
        #endif
    }
}
