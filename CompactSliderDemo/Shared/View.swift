// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension View {
    func monospacedDigitIfPossible() -> some View {
        if #available(iOS 15.0, *), #available(watchOSApplicationExtension 8.0, *) {
            return AnyView(monospacedDigit())
        }
        
        return AnyView(self)
    }
}
