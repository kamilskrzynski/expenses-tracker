//
//  ListView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 06/06/2022.
//

import SwiftUI

struct ListView: View {
    
    // MARK: State variables
    @State private var isSheetShowed: Bool = false
    @StateObject private var vm = ListViewModel()
    
    // MARK: body
    var body: some View {
        NavigationView {
            VStack {
                if vm.getAllEntries().isEmpty {
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
            .fullScreenCover(isPresented: $isSheetShowed, content: {
                AddExpenseView()
            })
        }
    }
    
    // MARK: toolbarLeading
    var toolbarLeading: some View {
        Button {
            
        } label: {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.primary)
                .font(.system(size: 24, weight: .regular))
        }
    }
    
    // MARK: toolbarTrailing
    var toolbarTrailing: some View {
        Button {
            isSheetShowed = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.primary)
                .font(.system(size: 24, weight: .regular))
        }
    }
    
    // MARK: entriesList
    var entriesList: some View {
        ForEach(Array(vm.groupedEntries), id: \.key) { day, entries in
            Section {
                ForEach(entries, id: \.id) { entry in
                    EntriesListRowView(entry: entry)
                        .contextMenu {
                            Button {
                                print("edit")
                            } label: {
                                Label {
                                    Text("Edit")
                                } icon: {
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            Button {
                                print("duplicate")
                            } label: {
                                Label {
                                    Text("Duplicate")
                                } icon: {
                                    Image(systemName: "square.on.square")
                                }
                            }
                            Button(role: .destructive) {
                                    vm.delete(entry)
                                    vm.groupedEntries = vm.groupEntryByDay()
                            } label: {
                                Label {
                                    Text("Delete")
                                } icon: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                }
                .listRowBackground(Color.clear)
            } header: {
                EntriesListHeaderView(day: day)
            }
            .listSectionSeparator(.hidden)
        }
    }

    // MARK: header
    var header: some View {
        VStack {
            Text("Spent this week")
                .foregroundColor(.secondary)
            HStack(spacing: 0) {
                
                Text(vm.getCurrentWeekAmountAsArray(.expenses)[0])
                    .foregroundColor(.primary)
                    .font(.system(size: 60, weight: .medium))
                VStack(alignment: .leading) {
                    HStack {
                        
                        Text(",\(vm.getCurrentWeekAmountAsArray(.expenses)[1])")
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
    
    // MARK: dragImage
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
