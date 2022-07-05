//
//  ListViewModel.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 08/06/2022.
//

import Foundation
import CoreData
import Collections

enum EntryType {
    case expenses, incomes
}

enum TimePeriod: String, CaseIterable {
    case week, month, year
}

enum Weekday: String, CaseIterable {
    
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    
}

typealias EntryGroup = OrderedDictionary<Date, [EntryViewModel]>


final class ListViewModel: ObservableObject {
    
    // MARK: Note
    /// This mess needs to be cleaned, for now it's just battle ground for testing
    
    @Published var expenses = [EntryViewModel]()
    @Published var incomes = [EntryViewModel]()
    @Published var allEntries = [EntryViewModel]()
    
    @Published var allExpensesForCurrentWeek = [EntryViewModel]()
    @Published var allIncomesForCurrentWeek = [EntryViewModel]()
    
    @Published var allExpensesForCurrentMonth = [EntryViewModel]()
    @Published var allIncomesForCurrentMonth = [EntryViewModel]()
    
    @Published var allExpensesForCurrentYear = [EntryViewModel]()
    @Published var allIncomesForCurrentYear = [EntryViewModel]()
    
    @Published var allExpensesForLastWeek = [EntryViewModel]()
    @Published var allIncomesForLastWeek = [EntryViewModel]()
    
    @Published var allEntriesFromDay = [EntryViewModel]()
    
    @Published var groupedCategories = [String: [EntryViewModel]]()
    @Published var groupedCategoriesKeys = [String]()
    
    @Published var expensesWeekly = [WeekChartData]()
    @Published var incomesWeekly = [WeekChartData]()
    @Published var expensesMonthly = [MonthChartData]()
    @Published var incomesMonthly = [MonthChartData]()
    @Published var expensesYearly = [YearChartData]()
    @Published var incomesYearly = [YearChartData]()
    
    @Published var maximumValue: Double = 0.0
    @Published var maximumValueAsString: String = ""

    // MARK: RefreshView
    func refreshView() {
        getAll(entryType: .expenses)
        getAll(entryType: .incomes)
        getAllEntries()
        getAllForCurrent(.week, .expenses)
        getAllForCurrent(.week, .incomes)
        getMaximumAmountFor(.week, .expenses)
        getMaximumAmountFor(.week, .incomes)
    }
    
    /// Getting all nessesary things from CoreData
    init() {
        getAllEntries()
        getAllForCurrent(.week, .expenses)
        getAllForCurrent(.week, .incomes)
        getAll(entryType: .expenses)
        getAll(entryType: .incomes)
        getMaximumAmountFor(.week, .expenses)
        getMaximumAmountFor(.week, .incomes)
        getAllBy(.week, .expenses)
        getAllBy(.week, .incomes)
        getAllBy(.month, .expenses)
        getAllBy(.month, .incomes)
        getAllBy(.year, .expenses)
        getAllBy(.year, .incomes)
        groupEntriesFor(.week, .expenses)
        groupEntriesFor(.week, .incomes)
        groupEntriesFor(.month, .expenses)
        groupEntriesFor(.month, .incomes)
        groupEntriesFor(.year, .expenses)
        groupEntriesFor(.year, .incomes)
    }
    
    /// Getting String representation of day
    func getDay(selectedDate: Date) -> String {
        if Calendar.current.isDateInToday(selectedDate) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(selectedDate) {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d" // OR "dd-MM-yyyy"
            
            let currentDateString: String = dateFormatter.string(from: selectedDate)
            return currentDateString
        }
    }
    
    func compare(entryType: EntryType) -> Int {
        switch entryType {
        case .expenses:
            guard getCurrentAmountFor(.week, .expenses) != 0.0 && getLastAmountFor(.week, .expenses) != 0.0 else {
                return 0
            }
            let currentWeek = getCurrentAmountFor(.week, .expenses)
            let lastWeek = getLastAmountFor(.week, .expenses)
            let percentage = 100 - (currentWeek * 100.0 / lastWeek)
            return Int(abs(round(percentage)))
        case .incomes:
            guard getCurrentAmountFor(.week, .incomes) != 0.0 && getLastAmountFor(.week, .incomes) != 0.0 else {
                return 0
            }
            let currentWeek = getCurrentAmountFor(.week, .incomes)
            let lastWeek = getLastAmountFor(.week, .incomes)
            let percentage = 100 - (currentWeek * 100.0 / lastWeek)
            return Int(abs(round(percentage)))
        }
    }
    
    // MARK: Group Entries
    /// Grouping expenses/incomes
    func groupEntriesFor(_ time: TimePeriod, _ entryType: EntryType) {
        switch time {
        case .week:
            switch entryType {
            case .expenses:
                self.groupedCategories = Dictionary(grouping: self.allExpensesForCurrentWeek, by: { $0.typeEmoji + "/" + $0.typeName })
                self.groupedCategoriesKeys = groupedCategories.map { $0.key }
            case .incomes:
                self.groupedCategories = Dictionary(grouping: self.allIncomesForCurrentWeek, by: { $0.typeEmoji + "/" + $0.typeName })
                self.groupedCategoriesKeys = groupedCategories
                    .map { $0.key }
            }
        case .month:
            switch entryType {
            case .expenses:
                self.groupedCategories = Dictionary(grouping: self.allExpensesForCurrentMonth, by: { $0.typeEmoji + "/" + $0.typeName })
                self.groupedCategoriesKeys = groupedCategories.map { $0.key }
            case .incomes:
                self.groupedCategories = Dictionary(grouping: self.allIncomesForCurrentMonth, by: { $0.typeEmoji + "/" + $0.typeName })
                self.groupedCategoriesKeys = groupedCategories
                    .map { $0.key }
            }
        case .year:
            switch entryType {
            case .expenses:
                self.groupedCategories = Dictionary(grouping: self.allExpensesForCurrentYear, by: { $0.typeEmoji + "/" + $0.typeName })
                self.groupedCategoriesKeys = groupedCategories.map { $0.key }
            case .incomes:
                self.groupedCategories = Dictionary(grouping: self.allIncomesForCurrentYear, by: { $0.typeEmoji + "/" + $0.typeName })
                self.groupedCategoriesKeys = groupedCategories
                    .map { $0.key }
            }
        }
    }
    
    /// Getting total spendings from single day
    func getSpendingsFromDay(day: Date) -> Double {
        
        var dailySpendings: Double = 0
        for expense in expenses {
            if Calendar.current.isDate(expense.dateCreated, inSameDayAs: day) {
                dailySpendings += expense.amount
            }
        }
        return dailySpendings
    }
    
    func countExpensesForCategory(_ time: TimePeriod, _ entryType: EntryType, _ category: String) -> Int {
        switch (time, entryType) {
        case (.week, .expenses):
            return self.allExpensesForCurrentWeek.filter { $0.typeName == category }.count
        case (.week, .incomes):
            return self.allIncomesForCurrentWeek.filter { $0.typeName == category }.count
        case (.month, .expenses):
            return self.allExpensesForCurrentMonth.filter { $0.typeName == category }.count
        case (.month, .incomes):
            return self.allIncomesForCurrentMonth.filter { $0.typeName == category }.count
        case (.year, .expenses):
            return self.allExpensesForCurrentYear.filter { $0.typeName == category }.count
        case (.year, .incomes):
            return self.allIncomesForCurrentYear.filter { $0.typeName == category }.count
        }
    }
    
    func countExpensesAmountForCategory(_ time: TimePeriod, _ entryType: EntryType, _ category: String) -> Double {
        switch (time, entryType) {
        case (.week, .expenses):
            return self.allExpensesForCurrentWeek
                .filter { $0.typeName == category }
                .map { $0.amount }
                .reduce(0, +)
        case (.week, .incomes):
            return self.allIncomesForCurrentWeek
                .filter { $0.typeName == category }
                .map { $0.amount }
                .reduce(0, +)
        case (.month, .expenses):
            return self.allExpensesForCurrentMonth
                .filter { $0.typeName == category }
                .map { $0.amount }
                .reduce(0, +)
        case (.month, .incomes):
            return self.allIncomesForCurrentMonth
                .filter { $0.typeName == category }
                .map { $0.amount }
                .reduce(0, +)
        case (.year, .expenses):
            return self.allExpensesForCurrentYear
                .filter { $0.typeName == category }
                .map { $0.amount }
                .reduce(0, +)
        case (.year, .incomes):
            return self.allIncomesForCurrentYear
                .filter { $0.typeName == category }
                .map { $0.amount }
                .reduce(0, +)
        }
    }
    
    /// Getting all entries
    func getAllEntries() {
        
        let entries = CoreDataManager.shared.getAllEntries()
        DispatchQueue.main.async {
            self.allEntries = entries.map(EntryViewModel.init)
        }
    }
    
    // MARK: GetAllForCurrentWeek
    /// Getting all expenses/income for current week/month/year
    func getAllForCurrent(_ timePeriod: TimePeriod, _ entryType: EntryType) {
        switch timePeriod {
        case .week:
            switch entryType {
            case .expenses:
                self.allExpensesForCurrentWeek = []
                let entries = CoreDataManager.shared.getAllForCurrentWeek(entryType: .expenses)
                DispatchQueue.main.async {
                    self.allExpensesForCurrentWeek = entries.map(EntryViewModel.init)
                }
            case .incomes:
                self.allIncomesForCurrentWeek = []
                let entries = CoreDataManager.shared.getAllForCurrentWeek(entryType: .incomes)
                DispatchQueue.main.async {
                    self.allIncomesForCurrentWeek = entries.map(EntryViewModel.init)
                }
            }
        case .month:
            switch entryType {
            case .expenses:
                self.allExpensesForCurrentMonth = []
                let entries = CoreDataManager.shared.getAllForCurrentMonth(entryType: .expenses)
                DispatchQueue.main.async {
                    self.allExpensesForCurrentMonth = entries.map(EntryViewModel.init)
                }
            case .incomes:
                self.allIncomesForCurrentMonth = []
                let entries = CoreDataManager.shared.getAllForCurrentMonth(entryType: .incomes)
                DispatchQueue.main.async {
                    self.allIncomesForCurrentMonth = entries.map(EntryViewModel.init)
                }
            }
        case .year:
            switch entryType {
            case .expenses:
                self.allExpensesForCurrentYear = []
                let entries = CoreDataManager.shared.getAllForCurrentYear(entryType: .expenses)
                DispatchQueue.main.async {
                    self.allExpensesForCurrentYear = entries.map(EntryViewModel.init)
                }
            case .incomes:
                self.allIncomesForCurrentYear = []
                let entries = CoreDataManager.shared.getAllForCurrentYear(entryType: .incomes)
                DispatchQueue.main.async {
                    self.allIncomesForCurrentYear = entries.map(EntryViewModel.init)
                }
            }
        }
    }
    
    // MARK: GetAllForLastWeek
    /// Getting all expenses/income for last week/month/year
    func getAllForLast(timePeriod: TimePeriod, entryType: EntryType) {
        switch timePeriod {
        case .week:
            switch entryType {
            case .expenses:
                let entries = CoreDataManager.shared.getAllForLastWeek(entryType: .expenses)
                DispatchQueue.main.async {
                    self.allExpensesForLastWeek = entries.map(EntryViewModel.init)
                }
            case .incomes:
                let entries = CoreDataManager.shared.getAllForLastWeek(entryType: .incomes)
                DispatchQueue.main.async {
                    self.allIncomesForLastWeek = entries.map(EntryViewModel.init)
                }
            }
        case .month:
            switch entryType {
            case .expenses:
                let entries = CoreDataManager.shared.getAllForLastWeek(entryType: .expenses)
                DispatchQueue.main.async {
                    self.allExpensesForLastWeek = entries.map(EntryViewModel.init)
                }
            case .incomes:
                let entries = CoreDataManager.shared.getAllForLastWeek(entryType: .incomes)
                DispatchQueue.main.async {
                    self.allIncomesForLastWeek = entries.map(EntryViewModel.init)
                }
            }
        case .year:
            switch entryType {
            case .expenses:
                let entries = CoreDataManager.shared.getAllForLastWeek(entryType: .expenses)
                DispatchQueue.main.async {
                    self.allExpensesForLastWeek = entries.map(EntryViewModel.init)
                }
            case .incomes:
                let entries = CoreDataManager.shared.getAllForLastWeek(entryType: .incomes)
                DispatchQueue.main.async {
                    self.allIncomesForLastWeek = entries.map(EntryViewModel.init)
                }
            }
        }
    }
    
    //MARK: GetAllBy
    /// Used to get all expenses/incomes for current week/month/year by day/month
    func getAllBy(_ timePeriod: TimePeriod, _ entryType: EntryType) {
        
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let daysOfMonth = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        switch timePeriod {
        case .week:
            switch entryType {
            case .expenses:
                expensesWeekly = []
                for day in days {
                    let entries = CoreDataManager.shared.getAllBy(.week, "expense", by: days.firstIndex(of: day)!)
                    let chartData = WeekChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
                    expensesWeekly.append(chartData)
                }
            case .incomes:
                incomesWeekly = []
                for day in days {
                    let entries = CoreDataManager.shared.getAllBy(.week, "income", by: days.firstIndex(of: day)!)
                    let chartData = WeekChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
                    incomesWeekly.append(chartData)
                }
            }
        case .month:
            switch entryType {
            case .expenses:
                expensesMonthly = []
                for day in daysOfMonth {
                    let entries = CoreDataManager.shared.getAllBy(.month, "expense", by: daysOfMonth.firstIndex(of: day)!)
                    let chartData = MonthChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
                    expensesMonthly.append(chartData)
                }
            case .incomes:
                incomesMonthly = []
                for day in daysOfMonth {
                    let entries = CoreDataManager.shared.getAllBy(.month, "income", by: daysOfMonth.firstIndex(of: day)!)
                    let chartData = MonthChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
                    incomesMonthly.append(chartData)
                }
            }
        case .year:
            switch entryType {
            case .expenses:
                expensesYearly = []
                for month in months {
                    let entries = CoreDataManager.shared.getAllBy(.year, "expense", by: months.firstIndex(of: month)!)
                    let chartData = YearChartData(month: month, amount: entries.map { $0.amount }.reduce(0, +))
                    expensesYearly.append(chartData)
                }
            case .incomes:
                incomesYearly = []
                for month in months {
                    let entries = CoreDataManager.shared.getAllBy(.year, "income", by: months.firstIndex(of: month)!)
                    let chartData = YearChartData(month: month, amount: entries.map { $0.amount }.reduce(0, +))
                    incomesYearly.append(chartData)
                }
            }
        }
    }
    
    // MARK: GetMaximum
    /// Used to get maximum amount of expense/income for Chart
    func getMaximumAmountFor(_ timePeriod: TimePeriod, _ entryType: EntryType) {
        switch timePeriod {
        case .week:
            switch entryType {
            case .expenses:
                let maxValue = self.expensesWeekly.max(by: {(chartData1, chartData2) -> Bool in
                    return chartData1.amount < chartData2.amount
                })
                self.maximumValue = maxValue?.amount ?? 0
                self.maximumValueAsString = String(format: "%.2f", maximumValue)
            case .incomes:
                let maxValue = self.incomesWeekly.max(by: {(chartData1, chartData2) -> Bool in
                    return chartData1.amount < chartData2.amount
                })
                self.maximumValue = maxValue?.amount ?? 0
                self.maximumValueAsString = String(format: "%.2f", maximumValue)
            }
        case .month:
            switch entryType {
            case .expenses:
                let maxValue = self.expensesMonthly.max(by: {(chartData1, chartData2) -> Bool in
                    return chartData1.amount < chartData2.amount
                })
                self.maximumValue = maxValue?.amount ?? 0
                self.maximumValueAsString = String(format: "%.2f", maximumValue)
            case .incomes:
                let maxValue = self.incomesMonthly.max(by: {(chartData1, chartData2) -> Bool in
                    return chartData1.amount < chartData2.amount
                })
                self.maximumValue = maxValue?.amount ?? 0
                self.maximumValueAsString = String(format: "%.2f", maximumValue)
            }
        case .year:
            switch entryType {
            case .expenses:
                let maxValue = self.expensesYearly.max(by: {(chartData1, chartData2) -> Bool in
                    return chartData1.amount < chartData2.amount
                })
                self.maximumValue = maxValue?.amount ?? 0
                self.maximumValueAsString = String(format: "%.2f", maximumValue)
            case .incomes:
                let maxValue = self.incomesYearly.max(by: {(chartData1, chartData2) -> Bool in
                    return chartData1.amount < chartData2.amount
                })
                self.maximumValue = maxValue?.amount ?? 0
                self.maximumValueAsString = String(format: "%.2f", maximumValue)
            }
        }
    }
    
    // MARK: GetAll
    /// Getting all expenses/incomes
    func getAll(entryType: EntryType) {
        switch entryType {
        case .expenses:
            let expenses = CoreDataManager.shared.getAllExpenses()
            DispatchQueue.main.async {
                self.expenses = expenses.map(EntryViewModel.init)
            }
        case .incomes:
            let incomes = CoreDataManager.shared.getAllIncomes()
            DispatchQueue.main.async {
                self.incomes = incomes.map(EntryViewModel.init)
            }
        }
    }
    // MARK: GetCurrentAmount -> [String]
    /// Getting amount of expenses/incomes from whole week as String
    func makeArray(doubleValue: Double) -> [String] {
        var totalString = ""
        totalString = String(format: "%.2f", doubleValue)
        let stringArray = totalString.components(separatedBy: ".")
        return stringArray
    }
    
    func getCurrentWeekAmountAsArray(_ entryType: EntryType) -> [String] {
        var total = 0.0
        switch entryType {
        case .expenses:
            for expense in allExpensesForCurrentWeek {
                total += expense.amount
            }
            return makeArray(doubleValue: total)
        case .incomes:
            for income in allIncomesForCurrentWeek {
                total += income.amount
            }
            return makeArray(doubleValue: total)
        }
    }
    
    // MARK: GetCurrentAmount -> Double
    /// Getting amount of expenses/incomes from whole week/month/year as Double
    func getCurrentAmountFor(_ time: TimePeriod, _ entryType: EntryType) -> Double {
        
        var total = 0.00
        
        switch time {
        case .week:
            switch entryType {
            case .expenses:
                for expense in allExpensesForCurrentWeek {
                    total += expense.amount
                }
                return total
            case .incomes:
                for income in allIncomesForCurrentWeek {
                    total += income.amount
                }
                return total
            }
        case .month:
            switch entryType {
            case .expenses:
                for expense in allExpensesForCurrentMonth {
                    total += expense.amount
                }
                return total
            case .incomes:
                for income in allIncomesForCurrentMonth {
                    total += income.amount
                }
                return total
            }
        case .year:
            switch entryType {
            case .expenses:
                for expense in allExpensesForCurrentYear {
                    total += expense.amount
                }
                return total
            case .incomes:
                for income in allIncomesForCurrentYear {
                    total += income.amount
                }
                return total
            }
        }
    }
    
    // MARK: GetCurrentAmount -> Double
    /// Getting amount of expenses/incomes from whole week as Double
    func getLastAmountFor(_ time: TimePeriod,_ entryType: EntryType) -> Double {
        
        var total = 0.0
        switch entryType {
        case .expenses:
            for expense in allExpensesForLastWeek {
                total += expense.amount
            }
            return total
        case .incomes:
            for income in allIncomesForLastWeek {
                total += income.amount
            }
            return total
        }
    }
    
    // MARK: GetAverage
    /// Used to get average amount of expenses/incomes from whole week/month/year
    func getAverageLine(_ time: TimePeriod, _ chartType: Double) -> Double {
        switch time {
        case .week:
            return chartType/Double(Date().dayNumberOfWeek()!)
        case .month:
            return chartType/Double(Date().dayNumberOfMonth()!)
        case .year:
            return chartType/Double(Date().monthNumberOfYear()!)
        }
    }

    /// Grouping entries to better representate data in ListView
    func groupEntryByDay() -> EntryGroup {
        
        guard !allEntries.isEmpty else { return [:] }
        let sortedEnteries = allEntries.sorted {
            $0.dateCreated > $1.dateCreated
        }
        let groupedEntries = EntryGroup(grouping: sortedEnteries) { $0.day }
        
        return groupedEntries
    }
}

// MARK: EntryViewModel
/// Used to create visual representation of CoreData Entity
struct EntryViewModel {
    
    let entry: Entry
    
    var id: NSManagedObjectID {
        return entry.objectID
    }
    
    var account: String {
        return entry.account ?? ""
    }
    
    var amount: Double {
        return entry.amount
    }
    
    var type: String {
        return entry.type ?? ""
    }
    
    var typeName: String {
        return entry.typeName ?? ""
    }
    
    var typeEmoji: String {
        return entry.typeEmoji ?? ""
    }
    
    var dateCreated: Date {
        return entry.dateCreated ?? Date()
    }
    
    var day: Date {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: dateCreated)
        return Calendar.current.date(from: dateComponents)!
    }
}
