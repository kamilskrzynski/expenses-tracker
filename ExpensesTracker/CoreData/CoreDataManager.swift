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
    
    /// Getting all expenses/incomes for current Week from CoreData
    func getAllForCurrentWeek(entryType: EntryType) -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().startOfWeek() as NSDate)
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().startOfNextWeek() as NSDate)
        
        switch entryType {
        case .expenses:
            let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "expense" as String)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
            fetchRequest.predicate = datePredicate
            
            do {
                return try persistentContainer.viewContext.fetch(fetchRequest)
            } catch {
                print(error)
                return []
            }
        case .incomes:
            let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "income" as String)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
            fetchRequest.predicate = datePredicate
            
            do {
                return try persistentContainer.viewContext.fetch(fetchRequest)
            } catch {
                print(error)
                return []
            }
        }
    }
    
    /// Getting all expenses/incomes for last Week from CoreData
    func getAllForLastWeek(entryType: EntryType) -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().startOfLastWeek() as NSDate)
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().startOfWeek() as NSDate)
        
        switch entryType {
        case .expenses:
            let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "expense" as String)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
            fetchRequest.predicate = datePredicate
            
            do {
                return try persistentContainer.viewContext.fetch(fetchRequest)
            } catch {
                print(error)
                return []
            }
        case .incomes:
            let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "income" as String)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
            fetchRequest.predicate = datePredicate
            
            do {
                return try persistentContainer.viewContext.fetch(fetchRequest)
            } catch {
                print(error)
                return []
            }
        }
    }
    
    /// Getting all expenses/incomes for current Week by each day from CoreData
    func getAllForCurrentWeekByDay(entryType: String, dayOfWeek: Int) -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().getNextDays(dayAmount: dayOfWeek) as NSDate)
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().getNextDays(dayAmount: dayOfWeek + 1) as NSDate)
        let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), entryType as String)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
        fetchRequest.predicate = datePredicate
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    /// Getting all expenses/incomes for current Month by each day from CoreData
    func getAllForCurrentMonthByDay(entryType: String, dayOfWeek: Int) -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().getNextDays(dayAmount: dayOfWeek) as NSDate)
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().getNextDays(dayAmount: dayOfWeek + 1) as NSDate)
        let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), entryType as String)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
        fetchRequest.predicate = datePredicate
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    /// Getting all expenses/incomes for current Year by each day from CoreData
    func getAllForCurrentYearByDay(entryType: String, dayOfWeek: Int) -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().getNextDays(dayAmount: dayOfWeek) as NSDate)
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().getNextDays(dayAmount: dayOfWeek + 1) as NSDate)
        let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), entryType as String)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
        fetchRequest.predicate = datePredicate
        
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



