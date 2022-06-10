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
            
            if vm.incomes.isEmpty {
                Spacer()
                Image("InsightsData")
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
                .navigationTitle(selectedOverviewCategory == .expenses ? "\(vm.getSpedings()[0]),\(vm.getSpedings()[1]) zł" : "\(vm.getIncomes()[0]),\(vm.getIncomes()[1]) zł")
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
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}
