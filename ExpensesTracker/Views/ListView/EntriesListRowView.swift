//
//  EntriesListRowView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 14/06/2022.
//

import SwiftUI

struct EntriesListRowView: View {
    
    let entry: EntryViewModel
    
    var body: some View {
        HStack {
            Text(entry.typeEmoji)
                .offset(y: -5)
                .font(.system(size: 30))
            VStack(spacing: 15) {
                HStack {
                    Text(entry.typeName)
                        .font(.system(size: 18, weight: .medium))
                    Spacer()
                    Text("\(entry.amount, format: .currency(code: "PLN"))")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(entry.type == "income" ? .appGreen : .primary)
                }
                Divider()
            }
        }
        .padding(.horizontal)
        .padding(.leading)
    }
}

struct EntriesListRowView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesListRowView(entry:
                            EntryViewModel(
                                entry: Entry(context:
                                                CoreDataManager.shared.persistentContainer.viewContext
                                            )
                            )
        )
    }
}
