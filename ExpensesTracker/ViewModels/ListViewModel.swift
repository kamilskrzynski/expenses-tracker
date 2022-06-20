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

enum TimePeriod {
    case week, month, year
}

enum Weekday: String, CaseIterable {
    
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    
    static var asArray: [Weekday] { return self.allCases }
    
    func asInt() -> Int {
        return Weekday.asArray.firstIndex(of: self)!
    }
}

typealias EntryGroup = OrderedDictionary<Date, [EntryViewModel]>


final class ListViewModel: ObservableObject {
    
    @Published var expenses = [EntryViewModel]()
    @Published var incomes = [EntryViewModel]()
    @Published var allEntries = [EntryViewModel]()
    @Published var allExpensesForCurrentWeek = [EntryViewModel]()
    @Published var allIncomesForCurrentWeek = [EntryViewModel]()
    @Published var allExpensesForLastWeek = [EntryViewModel]()
    @Published var allIncomesForLastWeek = [EntryViewModel]()
    @Published var allEntriesFromDay = [EntryViewModel]()
    @Published var groupedExpensesCategories = [String: [EntryViewModel]]()
    @Published var groupedExpensesCategoriesKeys = [String]()
    @Published var groupedIncomesCategories = [String: [EntryViewModel]]()
    @Published var groupedIncomesCategoriesKeys = [String]()
    @Published var expensesChartEntries = [WeekChartData]()
    @Published var expensesMaximum: Double = 0.0
    @Published var expensesMaximumString: String = ""
    @Published var incomesChartEntries = [WeekChartData]()
    @Published var incomesMaximum: Double = 0.0
    @Published var incomesMaximumString: String = ""
    
    // MARK: RefreshView
    func refreshView() {
        getAll(entryType: .expenses)
        getAll(entryType: .incomes)
        getAllEntries()
        getAllForCurrentWeek(entryType: .incomes)
        getAllForCurrentWeek(entryType: .expenses)
        getMaximumAmount(entryType: .expenses)
        getMaximumAmount(entryType: .incomes)
    }
    
    /// Getting all nessesary things from CoreData
    init() {
        getAllEntries()
        getAll(entryType: .expenses)
        getAll(entryType: .incomes)
        getAllForCurrentWeek(entryType: .expenses)
        getAllForCurrentWeek(entryType: .incomes)
        getAllForLastWeek(entryType: .expenses)
        getAllForLastWeek(entryType: .incomes)
        getAllByDay(timePeriod: .week, entryType: .expenses)
        getAllByDay(timePeriod: .week, entryType: .incomes)
        getMaximumAmount(entryType: .expenses)
        getMaximumAmount(entryType: .incomes)
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
            let currentWeek = getCurrentAmountDouble(entryType: .expenses)
            let lastWeek = getLastAmountDouble(entryType: .expenses)
            let percentage = 100 - (currentWeek * 100.0 / lastWeek)
            return Int(abs(round(percentage)))
        case .incomes:
            let currentWeek = getCurrentAmountDouble(entryType: .incomes)
            let lastWeek = getLastAmountDouble(entryType: .incomes)
            let percentage = 100 - (currentWeek * 100.0 / lastWeek)
            return Int(abs(round(percentage)))
        }
    }
    
    // MARK: Group Entries
    /// Grouping expenses/incomes
    func groupEntries(entryType: EntryType) {
        switch entryType {
        case .expenses:
            self.groupedExpensesCategories = Dictionary(grouping: self.allExpensesForCurrentWeek, by: { $0.typeEmoji + "/" + $0.typeName })
            self.groupedExpensesCategoriesKeys = groupedExpensesCategories.map { $0.key }
        case .incomes:
            self.groupedIncomesCategories = Dictionary(grouping: self.allIncomesForCurrentWeek, by: { $0.typeEmoji + "/" + $0.typeName })
            self.groupedIncomesCategoriesKeys = groupedIncomesCategories
                .map { $0.key }
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
    
    func countExpensesForCategory(_ category: String) -> Int {
        return self.allExpensesForCurrentWeek.filter { $0.typeName == category }.count
    }
    
    func countIncomesForCategory(_ category: String) -> Int {
        return self.allIncomesForCurrentWeek.filter { $0.typeName == category }.count
    }
    
    func countExpensesAmountForCategory(_ category: String) -> Double {
        return self.allExpensesForCurrentWeek
            .filter { $0.typeName == category }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    func countIncomesAmountForCategory(_ category: String) -> Double {
        return self.allIncomesForCurrentWeek
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
    /// Getting all expenses/income for current week
    func getAllForCurrentWeek(entryType: EntryType) {
        switch entryType {
        case .expenses:
            let entries = CoreDataManager.shared.getAllForCurrentWeek(entryType: .expenses)
            DispatchQueue.main.async {
                self.allExpensesForCurrentWeek = entries.map(EntryViewModel.init)
            }
        case .incomes:
            let entries = CoreDataManager.shared.getAllForCurrentWeek(entryType: .incomes)
            DispatchQueue.main.async {
                self.allIncomesForCurrentWeek = entries.map(EntryViewModel.init)
            }
        }
    }
    
    // MARK: GetAllForLastWeek
    /// Getting all expenses/income for current week
    func getAllForLastWeek(entryType: EntryType) {
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
    
    //MARK: GetAllForWeekByDay
    /// Used to get all expenses/incomes for current week by day
    func getAllByDay(timePeriod: TimePeriod, entryType: EntryType) {
        switch timePeriod {
        case .week:
            switch entryType {
            case .expenses:
                let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                for day in days {
                    let entries = CoreDataManager.shared.getAllForCurrentWeekByDay(entryType: "expense", dayOfWeek: days.firstIndex(of: day)!)
                    let chartData = WeekChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
                    expensesChartEntries.append(chartData)
                }
            case .incomes:
                let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                for day in days {
                    let entries = CoreDataManager.shared.getAllForCurrentWeekByDay(entryType: "income", dayOfWeek: days.firstIndex(of: day)!)
                    let chartData = WeekChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
                    incomesChartEntries.append(chartData)
                }
            }
        case .month:
            switch entryType {
            case .expenses:
                let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                for day in days {
                    let entries = CoreDataManager.shared.getAllForCurrentWeekByDay(entryType: "expense", dayOfWeek: days.firstIndex(of: day)!)
                    let chartData = WeekChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
                    expensesChartEntries.append(chartData)
                }
            case .incomes:
                let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                for day in days {
                    let entries = CoreDataManager.shared.getAllForCurrentWeekByDay(entryType: "income", dayOfWeek: days.firstIndex(of: day)!)
                    let chartData = WeekChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
                    incomesChartEntries.append(chartData)
                }
            }
        case .year:
            switch entryType {
            case .expenses:
                let months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
                for month in months {
                    let entries = CoreDataManager.shared.getAllForCurrentWeekByDay(entryType: "expense", dayOfWeek: months.firstIndex(of: month)!)
                    let chartData = WeekChartData(day: month, amount: entries.map { $0.amount }.reduce(0, +))
                    expensesChartEntries.append(chartData)
                }
            case .incomes:
                let months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
                for month in months {
                    let entries = CoreDataManager.shared.getAllForCurrentWeekByDay(entryType: "income", dayOfWeek: months.firstIndex(of: month)!)
                    let chartData = WeekChartData(day: month, amount: entries.map { $0.amount }.reduce(0, +))
                    incomesChartEntries.append(chartData)
                }
            }
        }
    }
    
    // MARK: GetMaximum
    /// Used to get maximum amount of expense/income for Chart
    func getMaximumAmount(entryType: EntryType) {
        switch entryType {
        case .expenses:
            let maxValue = self.expensesChartEntries.max(by: {(chartData1, chartData2)-> Bool in
                return chartData1.amount < chartData2.amount
            })
            self.expensesMaximum = maxValue?.amount ?? 0
            self.expensesMaximumString = String(format: "%.2f", expensesMaximum)
        case .incomes:
            let maxValue = self.incomesChartEntries.max(by: {(chartData1, chartData2)-> Bool in
                return chartData1.amount < chartData2.amount
            })
            self.incomesMaximum = maxValue?.amount ?? 0
            self.incomesMaximumString = String(format: "%.2f", incomesMaximum)
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
    func getCurrentAmount(entryType: EntryType) -> [String] {
        
        var total = 0.0
        var totalString = ""
        switch entryType {
        case .expenses:
            for expense in allExpensesForCurrentWeek {
                total += expense.amount
            }
            totalString = String(format: "%.2f", total)
            let stringArray = totalString.components(separatedBy: ".")
            return stringArray
        case .incomes:
            for income in allIncomesForCurrentWeek {
                total += income.amount
            }
            totalString = String(format: "%.2f", total)
            let stringArray = totalString.components(separatedBy: ".")
            return stringArray
        }
    }
    
    // MARK: GetCurrentAmount -> Double
    /// Getting amount of expenses/incomes from whole week as Double
    func getCurrentAmountDouble(entryType: EntryType) -> Double {
        
        var total = 0.0
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
    }
    
    // MARK: GetCurrentAmount -> Double
    /// Getting amount of expenses/incomes from whole week as Double
    func getLastAmountDouble(entryType: EntryType) -> Double {
        
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
    /// Used to get average amount of expenses/incomes from whole week
    func getAverageLine(chartType: Double) -> Double {
        
        return chartType/Double(Date().dayNumberOfWeek()!)
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
