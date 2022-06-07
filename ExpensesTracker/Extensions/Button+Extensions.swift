//
//  Button+Extensions.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 07/06/2022.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 60)
            .background(configuration.isPressed ? Circle().frame(width: 75, height: 75).foregroundColor(.secondary.opacity(0.1)) : Circle().frame(width: 70, height: 70).foregroundColor(.clear))
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
