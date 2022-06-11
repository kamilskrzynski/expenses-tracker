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
                    ScrollView(showsIndicators: false) {
                        
                        Text("Spent this week")
                            .foregroundColor(.secondary)
                        HStack(spacing: 0) {
                            
                            Text(vm.getSpendingsAmount()[0])
                            .foregroundColor(.primary)
                            .font(.system(size: 60, weight: .medium))
                            VStack(alignment: .leading) {
                                HStack {
                                    
                                Text(",\(vm.getSpendingsAmount()[1])")
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
                        Spacer()
                            .frame(height: 100)
                        ForEach(Array(vm.groupEntryByDay()), id: \.key) { day, entries in
                            Section {
                                ForEach(entries, id: \.id) { entry in
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
                                                    .foregroundColor(entry.type == "income" ? .appGreen : .primary)
                                            }
                                            Divider()
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.leading)
                                }
                                .listRowBackground(Color.clear)
                            } header: {
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
                            .listSectionSeparator(.hidden)
                        }
                        .onAppear {
                            print(Date())
                            print(Date().startOfWeek())
                        }
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
                vm.getAllEntries()
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
