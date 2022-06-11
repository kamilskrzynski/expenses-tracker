//
//  InsightsView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 06/06/2022.
//

import SwiftUI

enum SelectedOverviewCategory {
    case expenses
    case incomes
}

struct InsightsView: View {
    
    @StateObject private var vm = ListViewModel()
    @State private var selectedOverviewCategory: SelectedOverviewCategory = .expenses
    
    var body: some View {
        NavigationView {
            
            VStack {
                if vm.expenses.isEmpty {
                    Spacer()
                    Image("InsightsData")
                    Spacer()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(selectedOverviewCategory == .expenses ? " Total spent this week" : " Total revenue this week")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .navigationTitle(selectedOverviewCategory == .expenses ? "\(vm.getSpendingsAmount()[0]),\(vm.getSpendingsAmount()[1]) zł" : "\(vm.getIncomesAmount()[0]),\(vm.getIncomesAmount()[1]) zł")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button {
                                    selectedOverviewCategory = .expenses
                                } label: {
                                    HStack {
                                        if selectedOverviewCategory == .expenses {
                                            Image(systemName: "checkmark")
                                        }
                                        Text("Expenses")
                                    }
                                }
                                Button {
                                    selectedOverviewCategory = .incomes
                                } label: {
                                    HStack {
                                        if selectedOverviewCategory == .incomes {
                                            Image(systemName: "checkmark")
                                        }
                                        Text("Incomes")
                                    }
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 24, weight: .regular))
                            }
                        }
                    }
                }
            }
            .onAppear {
                vm.getAllExpenses()
                vm.getAllIncomes()
            }
        }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}
