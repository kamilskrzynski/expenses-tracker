//
//  ListViewModel.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 08/06/2022.
//

import Foundation
import CoreData

final class ListViewModel: ObservableObject {
    
    @Published var expenses = [EntryViewModel]()
    @Published var incomes = [EntryViewModel]()
    @Published var allEntries = [EntryViewModel]()
    
    
    init() {
        getAllEntries()
        getAllIncomes()
        getAllExpenses()
        print(expenses)
        print(incomes)
    }
    
    func getAllEntries() {
        
        let entries = CoreDataManager.shared.getAllEntries()
        DispatchQueue.main.async {
            self.allEntries = entries.map(EntryViewModel.init)
        }
    }
    
    func getAllExpenses() {
        
        let expenses = CoreDataManager.shared.getAllExpenses()
        DispatchQueue.main.async {
            self.expenses = expenses.map(EntryViewModel.init)
        }
    }
    
    func getAllIncomes() {
        
        let incomes = CoreDataManager.shared.getAllIncomes()
        DispatchQueue.main.async {
            self.incomes = incomes.map(EntryViewModel.init)
        }
    }
    
    func getAllSpedings() -> String {
        
        var total = 0.0
        var totalString = ""
        for expense in expenses {
            total += expense.amount
        }
        totalString = String(format: "%.2f", total)
        return totalString
    }
}

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
}
