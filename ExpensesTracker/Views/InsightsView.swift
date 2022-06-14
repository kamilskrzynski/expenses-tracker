//
//  InsightsView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 06/06/2022.
//

import SwiftUI

enum SelectedOverviewCategory {
    case expenses, incomes
}

enum TimeFrameSelection: String, CaseIterable {
    case Week, Month, Year
}

struct InsightsView: View {
    
    @StateObject private var vm = ListViewModel()
    @State private var selectedOverviewCategory: SelectedOverviewCategory = .expenses
    @State private var timeSelection: TimeFrameSelection = .Week
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.expenses.isEmpty {
                    insightsImage
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            header
                            chart
                            chartTimeFrames
                                .padding(.top, 15)
                            Spacer().frame(height: 30)
                            Divider()
                            weeklyEntries
                        }
                        .padding(.horizontal)
                    }
                    .navigationTitle(getNavTitle())
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            toolbarItems
                        }
                    }
                }
            }
            .onAppear {
                vm.getAllExpensesForCurrentWeek()
                vm.groupExpensesEntries()
                vm.groupIncomesEntries()
                vm.getExpensesMaximumAmount()
            }
        }
    }
    
    var insightsImage: some View {
        VStack {
            Spacer()
            Image("InsightsData")
            Spacer()
            Spacer()
        }
    }
    
    var weeklyEntries: some View {
        ForEach(selectedOverviewCategory == .expenses ? vm.groupedExpensesCategoriesKeys : vm.groupedIncomesCategoriesKeys, id: \.self) { key in
            let keyValues = key.components(separatedBy: "/")
            HStack {
                Text(keyValues[0])
                    .offset(y: -5)
                    .font(.system(size: 30))
                VStack(spacing: 15) {
                    HStack {
                        Text(keyValues[1])
                            .font(.system(size: 18, weight: .medium))
                        Text(selectedOverviewCategory == .expenses ? "x\(vm.countExpensesForCategory(keyValues[1]))" : "x\(vm.countIncomesForCategory(keyValues[1]))")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(selectedOverviewCategory == .expenses ? "\(vm.countExpensesAmountForCategory(keyValues[1]), format: .currency(code: "PLN"))" : "\(vm.countIncomesAmountForCategory(keyValues[1]), format: .currency(code: "PLN"))")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.primary)
                    }
                    
                    Divider()
                }
            }
            .padding(.leading)
        }
        .listRowBackground(Color.clear)
    }
    
    func getNavTitle() -> String {
        return selectedOverviewCategory == .expenses ? "\(vm.getSpendingsAmount()[0]),\(vm.getSpendingsAmount()[1]) zł" : "\(vm.getIncomesAmount()[0]),\(vm.getIncomesAmount()[1]) zł"
    }
    
    var header: some View {
        HStack {
            Text(selectedOverviewCategory == .expenses ? " Total spent this week" : " Total revenue this week")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
    
    var toolbarItems: some View {
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
    
    var chartTimeFrames: some View {
        HStack {
            ForEach(TimeFrameSelection.allCases, id: \.rawValue) { timeFrame in
                Button {
                    timeSelection = timeFrame
                } label: {
                    Text(timeFrame.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(timeSelection == timeFrame ? .primary : .appChartGray)
                        .padding(10)
                        .overlay(timeSelection == timeFrame ?
                                 RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary.opacity(0.4), lineWidth: 1.5) :
                                    RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.clear, lineWidth: 1.5)
                        )
                }
            }
        }
    }
    
    var chart: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 13) {
                ForEach(selectedOverviewCategory == .expenses ? vm.expensesChartEntries : vm.incomesChartEntries, id: \.self) { day in
                    VStack {
                        ZStack(alignment: .bottom) {
                            
                            RoundedRectangle(cornerRadius: 5)
                                .frame(
                                    width: (UIScreen.main.bounds.width - 200)/7,
                                    height: 150)
                                .foregroundColor(.appChartGray)
                            
                            RoundedRectangle(cornerRadius: 5)
                                .frame(
                                    width: (UIScreen.main.bounds.width - 200)/7,
                                    height: selectedOverviewCategory == .expenses ? vm.expensesMaximum == 0 ? 0 : (day.amount/vm.expensesMaximum)*150 : vm.incomesMaximum == 0 ? 0 : (day.amount/vm.incomesMaximum)*150)
                                .foregroundColor(selectedOverviewCategory == .expenses ? .primary : .appChartGreen)
                        }
                        Text(day.day)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                VStack(alignment: .leading) {
                    Text(selectedOverviewCategory == .expenses ? vm.expensesMaximumString : vm.incomesMaximumString)
                    Spacer()
                    Text("0")
                        .offset(y: -25)
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                Spacer()
            }
            if !Calendar.current.isDate(Date(), inSameDayAs: Date().startOfWeek()) {
                HStack {
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.secondary.opacity(0.7))
                        .frame(height: 1)
                    Text(selectedOverviewCategory == .expenses ? "\(vm.getAverageLine(chartType: vm.getSpendingsAmountDouble()), specifier: "%.2f")" : "\(vm.getAverageLine(chartType: vm.getIncomesAmountDouble()), specifier: "%.2f")")
                }
                .offset(y: selectedOverviewCategory == .expenses ?
                        vm.expensesMaximum == 0 ? -13 : -13-((vm.getAverageLine(chartType: vm.getSpendingsAmountDouble())/vm.expensesMaximum)*150) :
                            vm.incomesMaximum == 0 ? -13 : -13-((vm.getAverageLine(chartType: vm.getIncomesAmountDouble())/vm.incomesMaximum)*150)
                )
            }
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}
