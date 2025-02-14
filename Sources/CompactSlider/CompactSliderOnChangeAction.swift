// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct CompactSliderOnChangeActionKey: EnvironmentKey {
    static let defaultValue: ((CompactSliderStyleConfiguration) -> Void)? = nil
}

extension EnvironmentValues {
    var compactSliderOnChangeAction: ((CompactSliderStyleConfiguration) -> Void)? {
        get { self[CompactSliderOnChangeActionKey.self] }
        set { self[CompactSliderOnChangeActionKey.self] = newValue }
    }
}

// MARK: - View

extension View {
    /// Adds an action to perform when the slider configuration (progress, focus state and etc) changes.
    public func compactSliderOnChange(
        action: @escaping (_ configuration: CompactSliderStyleConfiguration) -> Void
    ) -> some View {
        environment(\.compactSliderOnChangeAction, action)
    }
}
