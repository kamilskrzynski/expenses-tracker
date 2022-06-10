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
    
    /// Initializing CoreData Stack
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "Expenses")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Couldn't load CoreData \(error.localizedDescription)")
            }
        }
    }
    
    /// Saving ManagedObjectContext
    func save() {
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    /// Getting all entries from CoreData
    func getAllEntries() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    /// Getting all expenses from CoreData
    func getAllExpenses() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "expense" as String)
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }

    }
    /// Getting all incomes from CoreData
    func getAllIncomes() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "income" as String)
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
}



