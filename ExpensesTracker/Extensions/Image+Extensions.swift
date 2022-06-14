//
//  Image+Extensions.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 14/06/2022.
//

import SwiftUI

extension Image {
    
    func tabViewImageStyle() -> some View {
        self
            .resizable()
            .frame(width: 1, height: 1)
    }
}
