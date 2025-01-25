// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ScaleZStackView: View {
    let alignment: Alignment
    let scaleViews: [ScaleView]
    
    var body: some View {
        ZStack(alignment: alignment) {
            ForEach(scaleViews, id: \.self) { $0 }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

#Preview {
    ScaleZStackView(
        alignment: .center,
        scaleViews: [
            .linear(count: 11, lineLength: 20),
            .linear(count: 51, lineLength: 10, skip: .each(5))
        ]
    )
}
