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
    
    var type: String {
        switch self {
        case .expenses:
            return "expense"
        case .incomes:
            return "income"
        }
    }
    
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
    
    @Published var allEntriesFromDay = [EntryViewModel]()
    
    @Published var maximumValue: Double = 0.0
    @Published var maximumValueAsString: String = ""
    
    // MARK: RefreshView
    func refreshView() {
        getAll(entryType: .expenses)
        getAll(entryType: .incomes)
        getAllEntries()
        getMaximumAmountFor(.week, .expenses)
        getMaximumAmountFor(.week, .incomes)
    }
    
    /// Getting all nessesary things from CoreData
    init() {
        getAllEntries()
        getAll(entryType: .expenses)
        getAll(entryType: .incomes)
        getMaximumAmountFor(.week, .expenses)
        getMaximumAmountFor(.week, .incomes)
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
    
    func compare(_ timePeriod: TimePeriod, _ entryType: EntryType) -> Int {
        guard getCurrentAmountFor(timePeriod, entryType) != 0.0 && getLastAmountFor(timePeriod, entryType) != 0.0 else {
            return 0
        }
        let current = getCurrentAmountFor(timePeriod, entryType)
        let last = getLastAmountFor(timePeriod, entryType)
        let percentage = 100 - (current * 100.0 / last)
        return Int(abs(round(percentage)))
    }
    
    // MARK: Group Entries
    /// Grouping expenses/incomes
    func groupEntriesFor(_ time: TimePeriod, _ entryType: EntryType) -> [String: [EntryViewModel]] {
        return Dictionary(grouping: self.getAllForCurrent(time, entryType), by: { $0.typeEmoji + "/" + $0.typeName })
    }
    
    func getKeyValues(_ time: TimePeriod, _ entryType: EntryType) -> [String] {
        return groupEntriesFor(time, entryType).map { $0.key }
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
        return self.getAllForCurrent(time, entryType).filter { $0.typeName == category }.count
    }
    
    func countExpensesAmountForCategory(_ time: TimePeriod, _ entryType: EntryType, _ category: String) -> Double {
        return self.getAllForCurrent(time, entryType)
            .filter { $0.typeName == category }
            .map { $0.amount }
            .reduce(0, +)
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
    func getAllForCurrent(_ timePeriod: TimePeriod, _ entryType: EntryType) -> [EntryViewModel] {
        return CoreDataManager
            .shared
            .getAllForCurrent(timePeriod, entryType)
            .map(EntryViewModel.init)
    }
    
    // MARK: GetAllForLastWeek
    /// Getting all expenses/income for last week/month/year
    func getAllForLast(_ timePeriod: TimePeriod, _ entryType: EntryType) -> [EntryViewModel] {
        return CoreDataManager
            .shared
            .getAllForLast(timePeriod, entryType)
            .map(EntryViewModel.init)
    }
    
    //MARK: GetAllBy
    /// Used to get all expenses/incomes for current week/month/year by day/month
    func getAllBy(_ timePeriod: TimePeriod, _ entryType: EntryType) -> [ChartData] {
        
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let daysOfMonth = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        var chartValues = [ChartData]()
        switch timePeriod {
        case .week:
            for day in days {
                let entries = CoreDataManager.shared.getAllBy(.week, entryType.type, by: days.firstIndex(of: day)!)
                let chartData = ChartData(timeInterval: day, amount: entries.map { $0.amount }.reduce(0, +))
                chartValues.append(chartData)
            }
        case .month:
            for day in daysOfMonth {
                let entries = CoreDataManager.shared.getAllBy(.month, entryType.type, by: daysOfMonth.firstIndex(of: day)!)
                let chartData = ChartData(timeInterval: day, amount: entries.map { $0.amount }.reduce(0, +))
                chartValues.append(chartData)
            }
        case .year:
            for month in months {
                let entries = CoreDataManager.shared.getAllBy(.year, entryType.type, by: months.firstIndex(of: month)!)
                let chartData = ChartData(timeInterval: month, amount: entries.map { $0.amount }.reduce(0, +))
                chartValues.append(chartData)
            }
        }
        return chartValues
    }
    
    // MARK: GetMaximum
    /// Used to get maximum amount of expense/income for Chart
    func getMaximumAmountFor(_ timePeriod: TimePeriod, _ entryType: EntryType) {
        
        let maxValue = getAllBy(timePeriod, entryType).max(by: {(chartData1, chartData2) -> Bool in
            return chartData1.amount < chartData2.amount
        })
        self.maximumValue = maxValue?.amount ?? 0
        self.maximumValueAsString = String(format: "%.2f", maximumValue)
        
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
        for expense in getAllForCurrent(.week, entryType) {
            total += expense.amount
        }
        return makeArray(doubleValue: total)
    }
    
    // MARK: GetCurrentAmount -> Double
    /// Getting amount of expenses/incomes from whole week/month/year as Double
    func getCurrentAmountFor(_ time: TimePeriod, _ entryType: EntryType) -> Double {
        
        var total = 0.00
        for entry in getAllForCurrent(time, entryType) {
            total += entry.amount
        }
        return total
    }
    
    // MARK: GetCurrentAmount -> Double
    /// Getting amount of expenses/incomes from whole week as Double
    func getLastAmountFor(_ time: TimePeriod,_ entryType: EntryType) -> Double {
        
        var total = 0.00
        
        for entry in getAllForLast(time, entryType) {
            total += entry.amount
        }
        return total
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
