//
//  CategoriesViewModel.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 07/06/2022.
//

import Foundation

class CategoriesViewModel: ObservableObject {
    
    @Published var emoji: String = ""
    @Published var name: String = ""
    @Published var selectedDate = Date()
    @Published var amount: String = "0"
    @Published var account: String = ""
    @Published var accountTypeButtonClicked: Bool = false
    @Published var expenseTypeButtonClicked: Bool = false
    @Published var datePickerClicked: Bool = false
    @Published var selectedAccount: Category = Category(emoji: "💳", name: "Credit Card")
    @Published var selectedExpense: Category = Category(emoji: "☕️", name: "Coffee")
    @Published var selectedType: String = "expense"
    
    var selectedDateString: String {
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
    
    func createExpense() {
        let manager = CoreDataManager.shared
        let entry = Entry(context: manager.persistentContainer.viewContext)
        
        entry.type = selectedType
        entry.typeName = selectedExpense.name
        entry.typeEmoji = selectedExpense.emoji
        entry.account = selectedAccount.name
        entry.amount = Double(amount) ?? 0.0
        entry.dateCreated = selectedDate
        
        manager.save()
    }
    
    func saveInitialExpenses() {
        var expensesArray = [Category]()
        
        expensesArray.append(Category(emoji: "🥑", name: "Grocieres"))
        expensesArray.append(Category(emoji: "🍪", name: "Snacks"))
        expensesArray.append(Category(emoji: "🍽", name: "Eating Out"))
        expensesArray.append(Category(emoji: "☕️", name: "Coffee"))
        expensesArray.append(Category(emoji: "🍹", name: "Drinks"))
        expensesArray.append(Category(emoji: "💄", name: "Beauty"))
        expensesArray.append(Category(emoji: "👕", name: "Clothing"))
        expensesArray.append(Category(emoji: "💍", name: "Accessories"))
        expensesArray.append(Category(emoji: "🎁", name: "Gifts"))
        expensesArray.append(Category(emoji: "🍿", name: "Entertainment"))
        expensesArray.append(Category(emoji: "🏠", name: "Home"))
        expensesArray.append(Category(emoji: "📱", name: "Tech"))
        expensesArray.append(Category(emoji: "📅", name: "Subscriptions"))
        expensesArray.append(Category(emoji: "🚗", name: "Car"))
        expensesArray.append(Category(emoji: "🚕", name: "Taxi"))
        expensesArray.append(Category(emoji: "🎗", name: "Charity"))
        expensesArray.append(Category(emoji: "📚", name: "Education"))
        expensesArray.append(Category(emoji: "💊", name: "Health"))
        expensesArray.append(Category(emoji: "🏝", name: "Travel"))
        expensesArray.append(Category(emoji: "🐶", name: "Pets"))
        expensesArray.append(Category(emoji: "🤷", name: "Miscellaneous"))
        print(expensesArray)
        
        let expenses = try! JSONEncoder().encode(expensesArray)
        UserDefaults.standard.set(expenses, forKey: "expensesCategories")
    }
    
    func getExpenses() -> [Category] {
        let expenses = UserDefaults.standard.data(forKey: "expensesCategories")
        let expensesArray = try! JSONDecoder().decode([Category].self, from: expenses!)
        return expensesArray
    }
    
    func addIncome() {
        var newIncomesArray = getIncomes()
        let newIncome = Category(emoji: emoji, name: name)
        newIncomesArray.append(newIncome)
        
        let newIncomes = try! JSONEncoder().encode(newIncomesArray)
        UserDefaults.standard.set(newIncomes, forKey: "incomesCategories")
    }
    
    func addExpense() {
        var newExpensesArray = getExpenses()
        let newExpense = Category(emoji: emoji, name: name)
        newExpensesArray.append(newExpense)
        
        let newExpenses = try! JSONEncoder().encode(newExpensesArray)
        UserDefaults.standard.set(newExpenses, forKey: "expensesCategories")
    }
    
    func addAccount() {
        var newAccountsArray = getAccounts()
        let newAccount = Category(emoji: emoji, name: name)
        newAccountsArray.append(newAccount)
        
        let newAccounts = try! JSONEncoder().encode(newAccountsArray)
        UserDefaults.standard.set(newAccounts, forKey: "accountsCategories")
    }
    
    func saveInitialIncomes() {
        var incomesArray = [Category]()
        
        
        incomesArray.append(Category(emoji: "👔", name: "Salary"))
        incomesArray.append(Category(emoji: "💼", name: "Business"))
        incomesArray.append(Category(emoji: "💸", name: "Other"))
        print(incomesArray)
        
        let incomes = try! JSONEncoder().encode(incomesArray)
        UserDefaults.standard.set(incomes, forKey: "incomesCategories")
    }
    
    func getIncomes() -> [Category] {
        let incomes = UserDefaults.standard.data(forKey: "incomesCategories")
        let incomesArray = try! JSONDecoder().decode([Category].self, from: incomes!)
        return incomesArray
    }
    
    func saveInitialAccounts() {
        var accountsArray = [Category]()
        
        accountsArray.append(Category(emoji: "💳", name: "Credit Card"))
        accountsArray.append(Category(emoji: "💵", name: "Cash"))
        print(accountsArray)
        
        let accounts = try! JSONEncoder().encode(accountsArray)
        UserDefaults.standard.set(accounts, forKey: "accountsCategories")
    }
    
    func getAccounts() -> [Category] {
        let accounts = UserDefaults.standard.data(forKey: "accountsCategories")
        let accountsArray = try! JSONDecoder().decode([Category].self, from: accounts!)
        return accountsArray
    }
    
    // MARK: Tapping buttons
    func buttonTapped(button: KeyboardNumber) {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            if amount == "0" {
                amount = button.rawValue
            } else {
                amount = amount + button.rawValue
            }
        case .comma:
            amount = amount + button.rawValue
        case .backspace:
            amount.removeLast()
            if amount.isEmpty {
                amount = "0"
            }
        }
    }
}
