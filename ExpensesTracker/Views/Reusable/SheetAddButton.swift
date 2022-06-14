//
//  SheetAddButton.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 07/06/2022.
//

import SwiftUI

struct SheetAddButton: View {
    
    let action: ()
    
    var body: some View {
        Button {
            DispatchQueue.main.async {
                action
            }
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 21, weight: .semibold))
                .foregroundColor(.secondary)
                .background(Circle().frame(width: 60, height: 60).foregroundColor(.gray.opacity(0.3)))
        }
    }
}
