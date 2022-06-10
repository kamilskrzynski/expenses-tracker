//
//  ListViewModel.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 08/06/2022.
//

import Foundation
import CoreData
import Collections


typealias EntryGroup = OrderedDictionary<Date, [EntryViewModel]>


final class ListViewModel: ObservableObject {
    
    @Published var expenses = [EntryViewModel]()
    @Published var incomes = [EntryViewModel]()
    @Published var allEntries = [EntryViewModel]()
    @Published var allEntriesFromDay = [EntryViewModel]()
    
    /// Getting all nessesary things from CoreData
    init() {
        getAllEntries()
        getAllIncomes()
        getAllExpenses()
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
    
    /// Getting total spendings from single day
    func getSpendingsFromDay(day: Date) -> String {
        
        var dailySpendings: Double = 0
        for expense in expenses {
            if Calendar.current.isDate(expense.dateCreated, inSameDayAs: day) {
                dailySpendings += expense.amount
            }
        }
        let dailySpendingsString = String(format: "%.2f", dailySpendings)
        return dailySpendingsString
    }
    
    /// Getting all entries
    /// Gonna be changed to get only from current week
    func getAllEntries() {
        
        let entries = CoreDataManager.shared.getAllEntries()
        DispatchQueue.main.async {
            self.allEntries = entries.map(EntryViewModel.init)
        }
    }
    
    /// Getting all expenses
    /// Gonna be changed to get only from current week
    func getAllExpenses() {
        
        let expenses = CoreDataManager.shared.getAllExpenses()
        DispatchQueue.main.async {
            self.expenses = expenses.map(EntryViewModel.init)
        }
    }
    
    /// Getting all incomes
    /// Gonna be changed to get only from current week
    func getAllIncomes() {
        
        let incomes = CoreDataManager.shared.getAllIncomes()
        DispatchQueue.main.async {
            self.incomes = incomes.map(EntryViewModel.init)
        }
    }
    
    
    func getIncomesAmount() -> [String] {
        
        var total = 0.0
        var totalString = ""
        for income in incomes {
            total += income.amount
        }
        totalString = String(format: "%.2f", total)
        let stringArray = totalString.components(separatedBy: ".")
        return stringArray
    }
    
    func getSpendingsAmount() -> [String] {
        
        var total = 0.0
        var totalString = ""
        for expense in expenses {
            total += expense.amount
        }
        totalString = String(format: "%.2f", total)
        let stringArray = totalString.components(separatedBy: ".")
        return stringArray
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
