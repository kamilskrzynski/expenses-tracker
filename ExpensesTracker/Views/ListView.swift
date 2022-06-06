//
//  ListView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 06/06/2022.
//

import SwiftUI

struct ListView: View {
    
    @State var expenses = []
    
    var body: some View {
        VStack {
            HStack {
             Image(systemName: "magnifyingglass")
                Spacer()
               Image(systemName: "plus.circle.fill")
            }
            .font(.system(size: 30, weight: .medium))
            .padding()
            if expenses.isEmpty {
                Spacer()
                Image("Drag")
                Spacer()
                Spacer()

            } else {
                Spacer()
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
