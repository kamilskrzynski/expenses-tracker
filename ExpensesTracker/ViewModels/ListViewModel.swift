//
//  ListViewModel.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 08/06/2022.
//

import Foundation
import CoreData
import Collections

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
    @Published var allEntriesFromDay = [EntryViewModel]()
    @Published var groupedExpensesCategories = [String: [EntryViewModel]]()
    @Published var groupedExpensesCategoriesKeys = [String]()
    @Published var groupedIncomesCategories = [String: [EntryViewModel]]()
    @Published var groupedIncomesCategoriesKeys = [String]()
    @Published var expensesChartEntries = [ChartData]()
    @Published var expensesMaximum: Double = 0.0
    @Published var expensesMaximumString: String = ""
    @Published var incomesChartEntries = [ChartData]()
    @Published var incomesMaximum: Double = 0.0
    @Published var incomesMaximumString: String = ""
    
    
    /// Getting all nessesary things from CoreData
    init() {
        getAllEntries()
        getAllIncomes()
        getAllExpenses()
        getAllExpensesForCurrentWeek()
        getAllIncomesForCurrentWeek()
        getAllExpensesForCurrentWeekByDay()
        getAllIncomesForCurrentWeekByDay()
        getExpensesMaximumAmount()
        getIncomesMaximumAmount()
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
    
    func groupExpensesEntries() {
        
        self.groupedExpensesCategories = Dictionary(grouping: self.allExpensesForCurrentWeek, by: { $0.typeEmoji + "/" + $0.typeName })
        self.groupedExpensesCategoriesKeys = groupedExpensesCategories.map { $0.key }
    }
    
    func groupIncomesEntries() {
        
        self.groupedIncomesCategories = Dictionary(grouping: self.allIncomesForCurrentWeek, by: { $0.typeEmoji + "/" + $0.typeName })
        self.groupedIncomesCategoriesKeys = groupedIncomesCategories
            .map { $0.key }
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
    
    /// Getting all expenses for current week
    func getAllExpensesForCurrentWeek() {
        
        let entries = CoreDataManager.shared.getAllExpensesForCurrentWeek()
        DispatchQueue.main.async {
            self.allExpensesForCurrentWeek = entries.map(EntryViewModel.init)
        }
    }
    
    /// Getting all incomes for current week
    func getAllIncomesForCurrentWeek() {
        
        let entries = CoreDataManager.shared.getAllIncomesForCurrentWeek()
        DispatchQueue.main.async {
            self.allIncomesForCurrentWeek = entries.map(EntryViewModel.init)
        }
    }
    
    func getAllExpensesForCurrentWeekByDay() {
        
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        for day in days {
            let entries = CoreDataManager.shared.getAllExpensesForCurrentWeekByDay(dayOfWeek: days.firstIndex(of: day)!)
            let chartData = ChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
            expensesChartEntries.append(chartData)
        }
    }
    
    func getAllIncomesForCurrentWeekByDay() {
        
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        for day in days {
            let entries = CoreDataManager.shared.getAllIncomesForCurrentWeekByDay(dayOfWeek: days.firstIndex(of: day)!)
            let chartData = ChartData(day: day, amount: entries.map { $0.amount }.reduce(0, +))
            incomesChartEntries.append(chartData)
        }
    }
    
    func getExpensesMaximumAmount() {
        let maxValue = self.expensesChartEntries.max(by: {(chartData1, chartData2)-> Bool in
            return chartData1.amount < chartData2.amount
        })
        self.expensesMaximum = maxValue?.amount ?? 0
        self.expensesMaximumString = String(format: "%.2f", expensesMaximum)
    }
    
    func getIncomesMaximumAmount() {
        let maxValue = self.incomesChartEntries.max(by: {(chartData1, chartData2)-> Bool in
            return chartData1.amount < chartData2.amount
        })
        self.incomesMaximum = maxValue?.amount ?? 0
        self.incomesMaximumString = String(format: "%.2f", incomesMaximum)
    }
    
    /// Getting all expenses
    func getAllExpenses() {
        
        let expenses = CoreDataManager.shared.getAllExpenses()
        DispatchQueue.main.async {
            self.expenses = expenses.map(EntryViewModel.init)
        }
    }
    
    /// Getting all incomes
    func getAllIncomes() {
        
        let incomes = CoreDataManager.shared.getAllIncomes()
        DispatchQueue.main.async {
            self.incomes = incomes.map(EntryViewModel.init)
        }
    }
    
    
    func getIncomesAmount() -> [String] {
        
        var total = 0.0
        var totalString = ""
        for income in allIncomesForCurrentWeek {
            total += income.amount
        }
        totalString = String(format: "%.2f", total)
        let stringArray = totalString.components(separatedBy: ".")
        return stringArray
    }
    
    
    func getSpendingsAmount() -> [String] {
        
        var total = 0.0
        var totalString = ""
        for expense in allExpensesForCurrentWeek {
            total += expense.amount
        }
        totalString = String(format: "%.2f", total)
        let stringArray = totalString.components(separatedBy: ".")
        return stringArray
    }
    
    func getIncomesAmountDouble() -> Double {
        
        var total = 0.0
        for income in allIncomesForCurrentWeek {
            total += income.amount
        }
        return total
    }
    
    
    func getSpendingsAmountDouble() -> Double {
        
        var total = 0.0
        for expense in allExpensesForCurrentWeek {
            total += expense.amount
        }
        return total
    }
    
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
