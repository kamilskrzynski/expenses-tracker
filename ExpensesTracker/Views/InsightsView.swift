//
//  InsightsView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 06/06/2022.
//

import SwiftUI

struct InsightsView: View {
    
    @StateObject private var vm = ListViewModel()
    @State private var selectedOverviewCategory: EntryType = .expenses
    @State private var timeSelection: TimePeriod = .week
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.expenses.isEmpty {
                    insightsImage
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            header
                            switch timeSelection {
                            case .week:
                                weekChart
                            case .month:
                                monthChart
                            case .year:
                                yearChart
                            }
                            
                            chartTimeFrames
                                .onAppear {
                                    vm.groupEntriesFor(timeSelection, selectedOverviewCategory)
                                }
                                .padding(.top, 15)
                            Spacer()
                                .frame(height: 30)
                            Divider()
                            switch timeSelection {
                            case .week:
                                weeklyEntries
                                    .padding(.trailing)
                            case .month:
                                monthlyEntries
                                    .padding(.trailing)
                            case .year:
                                yearlyEntries
                                    .padding(.trailing)
                            }
                        }
                        .padding(.leading)
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
                vm.refreshView()
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
        ForEach(vm.groupedCategoriesKeys, id: \.self) { key in
            let keyValues = key.components(separatedBy: "/")
            HStack {
                Text(keyValues[0])
                    .offset(y: -5)
                    .font(.system(size: 30))
                VStack(spacing: 15) {
                    HStack {
                        Text(keyValues[1])
                            .font(.system(size: 18, weight: .medium))
                        Text(selectedOverviewCategory == .expenses ? "x\(vm.countExpensesForCategoryForWeek(keyValues[1]))" : "x\(vm.countIncomesForCategoryForWeek(keyValues[1]))")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(selectedOverviewCategory == .expenses ? "\(vm.countExpensesAmountForCategoryForWeek(keyValues[1]), format: .currency(code: "PLN"))" : "\(vm.countIncomesAmountForCategoryForWeek(keyValues[1]), format: .currency(code: "PLN"))")
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
    
    var monthlyEntries: some View {
        ForEach(vm.groupedCategoriesKeys, id: \.self) { key in
            let keyValues = key.components(separatedBy: "/")
            HStack {
                Text(keyValues[0])
                    .offset(y: -5)
                    .font(.system(size: 30))
                VStack(spacing: 15) {
                    HStack {
                        Text(keyValues[1])
                            .font(.system(size: 18, weight: .medium))
                        Text(selectedOverviewCategory == .expenses ? "x\(vm.countExpensesForCategoryForMonth(keyValues[1]))" : "x\(vm.countIncomesForCategoryForMonth(keyValues[1]))")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(selectedOverviewCategory == .expenses ? "\(vm.countExpensesAmountForCategoryForMonth(keyValues[1]), format: .currency(code: "PLN"))" : "\(vm.countIncomesAmountForCategoryForMonth(keyValues[1]), format: .currency(code: "PLN"))")
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
    
    
    var yearlyEntries: some View {
        ForEach(vm.groupedCategoriesKeys, id: \.self) { key in
            let keyValues = key.components(separatedBy: "/")
            HStack {
                Text(keyValues[0])
                    .offset(y: -5)
                    .font(.system(size: 30))
                VStack(spacing: 15) {
                    HStack {
                        Text(keyValues[1])
                            .font(.system(size: 18, weight: .medium))
                        Text(selectedOverviewCategory == .expenses ? "x\(vm.countExpensesForCategoryForYear(keyValues[1]))" : "x\(vm.countIncomesForCategoryForYear(keyValues[1]))")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(selectedOverviewCategory == .expenses ? "\(vm.countExpensesAmountForCategoryForYear(keyValues[1]), format: .currency(code: "PLN"))" : "\(vm.countIncomesAmountForCategoryForYear(keyValues[1]), format: .currency(code: "PLN"))")
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
    
    // MARK: Navigation Title
    func getNavTitle() -> String {
            return "\(vm.getCurrentAmountFor(timeSelection, selectedOverviewCategory)) zł"
    }
    
    // MARK: Header
    var header: some View {
        HStack {
                Text(selectedOverviewCategory == .expenses ? " Total spent this \(timeSelection.rawValue.lowercased())" : " Total revenue this \(timeSelection.rawValue.lowercased())")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                Image(systemName: vm.getLastAmountFor(timeSelection, selectedOverviewCategory) > vm.getCurrentAmountFor(timeSelection , selectedOverviewCategory) ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(vm.getLastAmountFor(timeSelection, selectedOverviewCategory) > vm.getCurrentAmountFor(timeSelection, selectedOverviewCategory) ? .green : .red)
                Text("\(vm.compare(entryType: .expenses))%")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(vm.getLastAmountFor(timeSelection, selectedOverviewCategory) > vm.getCurrentAmountFor(timeSelection, selectedOverviewCategory) ? .green : .red)
                Spacer()
        }
    }
    
    // MARK: Toolbar
    var toolbarItems: some View {
        Menu {
            Button {
                selectedOverviewCategory = .expenses
                vm.groupEntriesFor(timeSelection, .expenses)
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
                vm.groupEntriesFor(timeSelection,.incomes)
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
    
    // MARK: Chart Time Frames
    var chartTimeFrames: some View {
        HStack {
            ForEach(TimePeriod.allCases, id: \.rawValue) { timeFrame in
                Button {
                    DispatchQueue.main.async {
                        timeSelection = timeFrame
                        vm.groupEntriesFor(timeFrame, selectedOverviewCategory)
                        vm.getMaximumAmountFor(timeFrame, selectedOverviewCategory)
                        vm.getAllBy(timeFrame, selectedOverviewCategory)
                        vm.getAllForCurrent(timeFrame, selectedOverviewCategory)
                    }
                } label: {
                    Text(timeFrame.rawValue.firstUppercased)
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
    
    var weekChart: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 13) {
                ForEach(selectedOverviewCategory == .expenses ? vm.expensesWeekly : vm.incomesWeekly, id: \.self) { day in
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
                                    height: selectedOverviewCategory == .expenses ? vm.expensesMaximumForWeek == 0 ? 0 : (day.amount/vm.expensesMaximumForWeek)*150 : vm.incomesMaximumForWeek == 0 ? 0 : (day.amount/vm.incomesMaximumForWeek)*150)
                                .foregroundColor(selectedOverviewCategory == .expenses ? .primary : .appChartGreen)
                        }
                        Text(day.day)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                VStack(alignment: .leading) {
                    Text(selectedOverviewCategory == .expenses ? vm.expensesMaximumStringForWeek : vm.incomesMaximumStringForWeek)
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
                    Text("\(vm.getAverageLineForWeek(chartType: vm.getCurrentAmountFor(.week, selectedOverviewCategory)), specifier: "%.2f")")
                        .font(.system(size: 16, weight: .medium))
                }
                .offset(y: selectedOverviewCategory == .expenses ?
                        vm.expensesMaximumForWeek == 0 ? -13 : -13-((vm.getAverageLineForWeek(chartType: vm.getCurrentAmountFor(.week, selectedOverviewCategory))/vm.expensesMaximumForWeek)*150) :
                            vm.incomesMaximumForWeek == 0 ? -13 : -13-((vm.getAverageLineForWeek(chartType: vm.getCurrentAmountFor(.week, selectedOverviewCategory))/vm.incomesMaximumForWeek)*150)
                )
            }
        }
    }
    
    var monthChart: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 3) {
                ForEach(selectedOverviewCategory == .expenses ? vm.expensesMonthly : vm.incomesMonthly, id: \.self) { day in
                    VStack {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(
                                    width: (UIScreen.main.bounds.width - 200)/31,
                                    height: 150)
                                .foregroundColor(.clear)
                            
                            RoundedRectangle(cornerRadius: 5)
                                .frame(
                                    width: (UIScreen.main.bounds.width - 200)/31,
                                    height: (UIScreen.main.bounds.width - 200)/31)
                                .foregroundColor(.appChartGray)
                            
                            RoundedRectangle(cornerRadius: 5)
                                .frame(
                                    width: (UIScreen.main.bounds.width - 200)/31,
                                    height: selectedOverviewCategory == .expenses ? vm.expensesMaximumForMonth == 0 ? 0 : (day.amount/vm.expensesMaximumForMonth)*150 : vm.incomesMaximumForMonth == 0 ? 0 : (day.amount/vm.incomesMaximumForMonth)*150)
                                .foregroundColor(selectedOverviewCategory == .expenses ? .primary : .appChartGreen)
                        }
                        if day.day == "1" || day.day == "7" || day.day == "14" || day.day == "21" || day.day == "28" {
                            Text(day.day)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                        } else {
                            Text("1")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.clear)
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text(selectedOverviewCategory == .expenses ? vm.expensesMaximumStringForMonth : vm.incomesMaximumStringForMonth)
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
                    Text("\(vm.getAverageLineForMonth(chartType: vm.getCurrentAmountFor(.month, selectedOverviewCategory)), specifier: "%.2f")")
                        .font(.system(size: 16, weight: .medium))
                }
                .offset(y: selectedOverviewCategory == .expenses ?
                        vm.expensesMaximumForMonth == 0 ? -13 : -13-((vm.getAverageLineForMonth(chartType: vm.getCurrentAmountFor(.month, selectedOverviewCategory))/vm.expensesMaximumForMonth)*150) :
                            vm.incomesMaximumForMonth == 0 ? -13 : -13-((vm.getAverageLineForMonth(chartType: vm.getCurrentAmountFor(.month, selectedOverviewCategory))/vm.incomesMaximumForMonth)*150)
                )
            }
        }
    }
    
    var yearChart: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 8) {
                ForEach(selectedOverviewCategory == .expenses ? vm.expensesYearly : vm.incomesYearly, id: \.self) { month in
                    VStack {
                        ZStack(alignment: .bottom) {
                            
                            RoundedRectangle(cornerRadius: 5)
                                .frame(
                                    width: (UIScreen.main.bounds.width - 200)/12,
                                    height: 150)
                                .foregroundColor(.appChartGray)
                            
                            RoundedRectangle(cornerRadius: 5)
                                .frame(
                                    width: (UIScreen.main.bounds.width - 200)/12,
                                    height: selectedOverviewCategory == .expenses ? vm.expensesMaximumForYear == 0 ? 0 : (month.amount/vm.expensesMaximumForYear)*150 : vm.incomesMaximumForYear == 0 ? 0 : (month.amount/vm.incomesMaximumForYear)*150)
                                .foregroundColor(selectedOverviewCategory == .expenses ? .primary : .appChartGreen)
                        }
                        Text(month.month.prefix(1))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                VStack(alignment: .leading) {
                    Text(selectedOverviewCategory == .expenses ? vm.expensesMaximumStringForYear : vm.incomesMaximumStringForYear)
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
                    Text("\(vm.getAverageLineForYear(chartType: vm.getCurrentAmountFor(.year, selectedOverviewCategory)), specifier: "%.2f")")
                        .font(.system(size: 16, weight: .medium))
                }
                .offset(y: selectedOverviewCategory == .expenses ?
                        vm.expensesMaximumForYear == 0 ? -13 : -13-((vm.getAverageLineForYear(chartType: vm.getCurrentAmountFor(.year, selectedOverviewCategory))/vm.expensesMaximumForYear)*150) :
                            vm.incomesMaximumForYear == 0 ? -13 : -13-((vm.getAverageLineForYear(chartType: vm.getCurrentAmountFor(.year, selectedOverviewCategory))/vm.incomesMaximumForYear)*150)
                )
            }
        }
    }
    
    func refreshView() {
        // TODO
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
