//
//  CoreDataManager.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 08/06/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "Expenses")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Couldn't load CoreData \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func create(account: String, amount: Double, type: String, typeName: String, typeEmoji: String, dateCreated: Date) {
        
        let expense = Entry()
        expense.account = account
        expense.amount = amount
        expense.type = type
        expense.typeName = typeName
        expense.typeEmoji = typeEmoji
        expense.dateCreated = dateCreated
        
        save()
    }
    
    func getAllEntries() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func getAllIncomes() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", "income" as String)
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func getAllExpenses() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", "expense" as String)
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }

    }
}



