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
    
    /// Fetch
    func fetch(fetchRequest: NSFetchRequest<Entry>) -> [Entry] {
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
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
        
        return fetch(fetchRequest: fetchRequest)
    }
    
    /// Getting all expenses/incomes for current Week/Month/Year from CoreData
    func getAllForCurrent(_ timePeriod: TimePeriod, _ entryType: EntryType) -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        var fromPredicate = NSPredicate()
        var toPredicate = NSPredicate()
        let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "expense" as String)
        let incomePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "income" as String)
        
        switch timePeriod {
        case .week:
            fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().startOfWeek() as NSDate)
            toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().startOfNextWeek() as NSDate)
            
            switch entryType {
            case .expenses:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            case .incomes:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, incomePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            }
        case .month:
            fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().startOfMonth() as NSDate)
            toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().startOfNextMonth() as NSDate)
            
            switch entryType {
            case .expenses:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            case .incomes:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, incomePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            }
        case .year:
            fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().startOfYear() as NSDate)
            toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().startOfNextYear() as NSDate)
            
            switch entryType {
            case .expenses:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            case .incomes:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, incomePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            }
        }
    }
    
    /// Getting all expenses/incomes for last Week/Month/Year from CoreData
    func getAllForLast(_ timePeriod: TimePeriod, _ entryType: EntryType) -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let incomePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "income" as String)
        let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "expense" as String)
        var fromPredicate = NSPredicate()
        var toPredicate = NSPredicate()
        
        switch timePeriod {
        case .week:
            fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().startOfLastWeek() as NSDate)
            toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().startOfWeek() as NSDate)
            
            switch entryType {
            case .expenses:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            case .incomes:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, incomePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            }
        case .month:
            fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().startOfLastMonth() as NSDate)
            toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().startOfMonth() as NSDate)
            switch entryType {
            case .expenses:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            case .incomes:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, incomePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            }
        case .year:
            fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().startOfLastYear() as NSDate)
            toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().startOfYear() as NSDate)
            
            switch entryType {
            case .expenses:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            case .incomes:
                let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, incomePredicate])
                fetchRequest.predicate = datePredicate
                
                return fetch(fetchRequest: fetchRequest)
            }
        }
    }
    
    /// Getting all expenses/incomes for current Week/Month/Year by each day/month from CoreData
    func getAllBy(_ timePeriod: TimePeriod, _ entryType: String, by: Int) -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let expensePredicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), entryType as String)
        var fromPredicate = NSPredicate()
        var toPredicate = NSPredicate()
        
        switch timePeriod {
        case .week:
            fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().getNextDays(dayAmount: by) as NSDate)
            toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().getNextDays(dayAmount: by + 1) as NSDate)
        case .month:
            fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().getNextDaysOfMonth(dayAmount: by) as NSDate)
            toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().getNextDaysOfMonth(dayAmount: by + 1) as NSDate)
        case .year:
            fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.dateCreated), Date().getNextMonths(monthAmount: by) as NSDate)
            toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.dateCreated), Date().getNextMonths(monthAmount: by + 1) as NSDate)
        }
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, expensePredicate])
        fetchRequest.predicate = datePredicate
        
        return fetch(fetchRequest: fetchRequest)
    }
    
    /// Getting all expenses from CoreData
    func getAllExpenses() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "expense" as String)
        
        return fetch(fetchRequest: fetchRequest)
    }
    
    /// Getting all incomes from CoreData
    func getAllIncomes() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Entry.type), "income" as String)
        
        return fetch(fetchRequest: fetchRequest)
    }
}



