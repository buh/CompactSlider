// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ProgressViewWrapper: View {
    @Environment(\.compactSliderProgressView) var progressView
    
    public var body: some View {
        progressView
    }
}
