//
//  ListView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 06/06/2022.
//

import SwiftUI

struct ListView: View {
    
    @State private var isSheetShowed: Bool = false
    @StateObject private var vm = ListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.expenses.isEmpty {
                    Spacer()
                    Image("Drag")
                    Spacer()
                    Spacer()
                    
                } else {
                    ScrollView {
                        
                        Text("Spent this week")
                            .foregroundColor(.secondary)
                        Text(vm.getAllSpedings())
                            .foregroundColor(.primary)
                            .font(.system(size: 50, weight: .medium))
                        Spacer()
                            .frame(height: 100)
                        
                        ForEach(vm.allEntries, id: \.id) { expense in
                            
                            HStack {
                                Text(expense.typeEmoji)
                                    .offset(y: 5)
                                    .font(.system(size: 30))
                                VStack(spacing: 15) {
                                    Divider()
                                    HStack {
                                        Text(expense.typeName)
                                        Spacer()
                                        Text("\(expense.amount, format: .currency(code: "PLN"))")
                                            .foregroundColor(expense.type == "income" ? .green : .primary)
                                    }
                                }
                            }
                            .frame(height: 50)
                            .padding(.horizontal)
                        }
                        .padding(.leading, 20)
                        .listStyle(.plain)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                            .font(.system(size: 24, weight: .regular))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isSheetShowed = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 24, weight: .regular))
                    }
                }
            }
            .fullScreenCover(isPresented: $isSheetShowed, onDismiss: {
                vm.getAllExpenses()
                vm.getAllIncomes()
            }, content: {
                AddExpenseView()
            })
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
