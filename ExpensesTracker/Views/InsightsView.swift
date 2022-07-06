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
                if vm.getAll(selectedOverviewCategory).isEmpty {
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
                                .padding(.top, 15)
                            Spacer()
                                .frame(height: 30)
                            Divider()
                                entries
                                    .padding(.trailing)

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
    
    var entries: some View {
        ForEach(vm.getKeyValues(timeSelection, selectedOverviewCategory), id: \.self) { key in
            let keyValues = key.components(separatedBy: "/")
            HStack {
                Text(keyValues[0])
                    .offset(y: -5)
                    .font(.system(size: 30))
                VStack(spacing: 15) {
                    HStack {
                        Text(keyValues[1])
                            .font(.system(size: 18, weight: .medium))
                        Text("x\(vm.countExpensesForCategory(timeSelection, selectedOverviewCategory, keyValues[1]))")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(vm.countExpensesAmountForCategory(timeSelection, selectedOverviewCategory, keyValues[1]), format: .currency(code: "PLN"))")
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
                Text("\(vm.compare(timeSelection, selectedOverviewCategory))%")
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
    
    // MARK: Chart Time Frames
    var chartTimeFrames: some View {
        HStack {
            ForEach(TimePeriod.allCases, id: \.rawValue) { timeFrame in
                Button {
                    DispatchQueue.main.async {
                        timeSelection = timeFrame
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
                ForEach(vm.getAllBy(timeSelection, selectedOverviewCategory), id: \.self) { timeInterval in
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
                                    height: vm.getMaximumAmountFor(timeSelection, selectedOverviewCategory) == 0 ? 0 : (timeInterval.amount/vm.getMaximumAmountFor(timeSelection, selectedOverviewCategory))*150)
                                .foregroundColor(selectedOverviewCategory == .expenses ? .primary : .appChartGreen)
                        }
                        Text(timeInterval.timeInterval)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                chartValues
                Spacer()
            }
            if !Calendar.current.isDate(Date(), inSameDayAs: Date().startOfWeek()) {
                averageLine
            }
        }
    }
    
    var monthChart: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 3) {
                ForEach(vm.getAllBy(timeSelection, selectedOverviewCategory), id: \.self) { timeInterval in
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
                                    height: vm.getMaximumAmountFor(timeSelection, selectedOverviewCategory) == 0 ? 0 : (timeInterval.amount/vm.getMaximumAmountFor(timeSelection, selectedOverviewCategory))*150)
                                .foregroundColor(selectedOverviewCategory == .expenses ? .primary : .appChartGreen)
                        }
                        if timeInterval.timeInterval == "1" || timeInterval.timeInterval == "7" || timeInterval.timeInterval == "14" || timeInterval.timeInterval == "21" || timeInterval.timeInterval == "28" {
                            Text(timeInterval.timeInterval)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                        } else {
                            Text("1")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.clear)
                        }
                    }
                }
                chartValues
                Spacer()
            }
            if !Calendar.current.isDate(Date(), inSameDayAs: Date().startOfMonth()) {
                averageLine
            }
        }
    }
    
    var yearChart: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 8) {
                ForEach(vm.getAllBy(timeSelection, selectedOverviewCategory), id: \.self) { timeInterval in
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
                                    height: vm.getMaximumAmountFor(timeSelection, selectedOverviewCategory) == 0 ? 0 : (timeInterval.amount/vm.getMaximumAmountFor(timeSelection, selectedOverviewCategory))*150)
                                .foregroundColor(selectedOverviewCategory == .expenses ? .primary : .appChartGreen)
                        }
                        Text(timeInterval.timeInterval.prefix(1))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                chartValues
                Spacer()
            }
            if !Calendar.current.isDate(Date(), inSameDayAs: Date().startOfYear()) {
                averageLine
            }
        }
    }
    
    var chartValues: some View {
        VStack(alignment: .leading) {
            Text(String(format: "%.2f", vm.getMaximumAmountFor(timeSelection, selectedOverviewCategory)))
            Spacer()
            Text("0")
                .offset(y: -25)
        }
        .font(.system(size: 14, weight: .medium))
        .foregroundColor(.secondary)
    }
    
    var averageLine: some View {
        HStack {
            Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.secondary.opacity(0.7))
                .frame(height: 1)
            Text("\(vm.getAverageLine(timeSelection, vm.getCurrentAmountFor(timeSelection, selectedOverviewCategory)), specifier: "%.2f")")
                .font(.system(size: 16, weight: .medium))
        }
        .offset(y: vm.getMaximumAmountFor(timeSelection, selectedOverviewCategory) == 0 ? -13 : -13-((vm.getAverageLine(timeSelection, vm.getCurrentAmountFor(timeSelection, selectedOverviewCategory))/vm.getMaximumAmountFor(timeSelection, selectedOverviewCategory))*150))
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
