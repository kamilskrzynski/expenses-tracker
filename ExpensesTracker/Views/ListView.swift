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
                    dragImage
                } else {
                    ScrollView(showsIndicators: false) {
                        header
                        Spacer()
                            .frame(height: 100)
                        entriesList
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
                refreshView()
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
                
                Text(vm.getExpensesAmount()[0])
                    .foregroundColor(.primary)
                    .font(.system(size: 60, weight: .medium))
                VStack(alignment: .leading) {
                    HStack {
                        
                        Text(",\(vm.getExpensesAmount()[1])")
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
    
    // MARK: RefreshView
    func refreshView() {
        vm.getAll(entryType: .expenses)
        vm.getAll(entryType: .incomes)
        vm.getAllEntries()
        vm.getAllForCurrentWeek(entryType: .incomes)
        vm.getAllForCurrentWeek(entryType: .expenses)
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
