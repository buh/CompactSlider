//
//  View.swift
//  CompactSliderDemo
//
//  Created by bukhtin on 02/05/2022.
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
