//
//  InsightsView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 06/06/2022.
//

import SwiftUI

struct InsightsView: View {
    
    @State private var expenses = []
    var body: some View {
        VStack {

            if expenses.isEmpty {
                Spacer()
                Image("InsightsData")
                Spacer()

            } else {
                Spacer()
            }
        }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}
