//
//  EntriesListHeaderView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 14/06/2022.
//

import SwiftUI

struct EntriesListHeaderView: View {
    
    @StateObject private var vm = ListViewModel()
    let day: Date
    
    var body: some View {
            Spacer()
                .frame(height: 30)
            HStack {
                Spacer()
                    .frame(width: 40)
                VStack(spacing: 15) {
                    HStack {
                        Text(vm.getDay(selectedDate: day))
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .regular))
                        Spacer()
                        Text("\(vm.getSpendingsFromDay(day: day), format: .currency(code: "PLN"))")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14, weight: .medium))
                    }
                    Divider()
                }
            }
            .padding(.horizontal)
            .padding(.leading)
    }
}

struct EntriesListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesListHeaderView(day: Date())
    }
}
