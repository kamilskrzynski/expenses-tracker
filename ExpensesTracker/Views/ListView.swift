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
    @State var expenses = [YearChartData]()
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.expenses.isEmpty {
                    dragImage
                } else {
                    ScrollView(showsIndicators: false) {
                        header
                        Spacer()
                            .frame(height: 100)
                        entriesList
                            .onAppear {
                                    let entries = CoreDataManager.shared.getAllForCurrentYearByMonth(entryType: "expense", monthOfYear: 6)
                                    let chartData = YearChartData(month: "J", amount: entries.map { $0.amount }.reduce(0, +))
                                    expenses.append(chartData)
                                print(Date().startOfYear())
                                print(Date().getNextMonths(monthAmount: 1))
                                print(Date().getNextMonths(monthAmount: 2))
                                print(Date().getNextMonths(monthAmount: 3))
                                print(Date().getNextMonths(monthAmount: 4))
                                print(Date().getNextMonths(monthAmount: 5))
                                print(Date().getNextMonths(monthAmount: 6))
                                print(Date().getNextMonths(monthAmount: 7))
                                print(Date().getNextMonths(monthAmount: 8))
                                print(Date().getNextMonths(monthAmount: 9))
                                print(Date().getNextMonths(monthAmount: 10))
                                print(Date().getNextMonths(monthAmount: 11))
                                print(Date().getNextMonths(monthAmount: 12))
                                print(expenses)
                                
                            }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    toolbarLeading
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarTrailing
                }
            }
            .fullScreenCover(isPresented: $isSheetShowed, onDismiss: {
                vm.refreshView()
            }, content: {
                AddExpenseView()
            })
        }
    }
    
    // MARK: ToolbarLeading
    var toolbarLeading: some View {
        Button {
            
        } label: {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.primary)
                .font(.system(size: 24, weight: .regular))
        }
    }
    
    // MARK: ToolbarTrailing
    var toolbarTrailing: some View {
        Button {
            isSheetShowed = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.primary)
                .font(.system(size: 24, weight: .regular))
        }
    }
    
    // MARK: EntriesList
    var entriesList: some View {
        ForEach(Array(vm.groupEntryByDay()), id: \.key) { day, entries in
            Section {
                ForEach(entries, id: \.id) { entry in
                    EntriesListRowView(entry: entry)
                }
                .listRowBackground(Color.clear)
            } header: {
                EntriesListHeaderView(day: day)
            }
            .listSectionSeparator(.hidden)
        }
    }

    // MARK: Header
    var header: some View {
        VStack {
            Text("Spent this week")
                .foregroundColor(.secondary)
            HStack(spacing: 0) {
                
                Text(vm.getCurrentAmount(entryType: .expenses)[0])
                    .foregroundColor(.primary)
                    .font(.system(size: 60, weight: .medium))
                VStack(alignment: .leading) {
                    HStack {
                        
                        Text(",\(vm.getCurrentAmount(entryType: .expenses)[1])")
                            .foregroundColor(.primary)
                            .font(.system(size: 25, weight: .medium))
                        Text("zł")
                            .foregroundColor(.secondary)
                            .font(.system(size: 25, weight: .medium))
                    }
                    Spacer()
                }
            }
            .frame(height: 55)
        }
    }
    
    // MARK: DragImage
    var dragImage: some View {
        VStack {
            Spacer()
            Image("Drag")
            Spacer()
            Spacer()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
