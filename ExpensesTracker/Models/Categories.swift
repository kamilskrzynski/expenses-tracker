//
//  Categories.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 07/06/2022.
//

import Foundation

struct Categories {
    
    let expensesCategories: [Category] = [
        Category(name: "🥑 Grocieres"),
        Category(name: "🍪 Snacks"),
        Category(name: "🍽 Eating Out"),
        Category(name: "☕️ Coffee"),
        Category(name: "🍹 Drinks"),
        Category(name: "💄 Beauty"),
        Category(name: "👕 Clothing"),
        Category(name: "💍 Accessories"),
        Category(name: "🎁 Gifts"),
        Category(name: "🍿 Entertainment"),
        Category(name: "🏠 Home"),
        Category(name: "📱 Tech"),
        Category(name: "📅 Subscriptions"),
        Category(name: "🚗 Car"),
        Category(name: "🚕 Taxi"),
        Category(name: "🎗 Charity"),
        Category(name: "📚 Education"),
        Category(name: "💊 Health"),
        Category(name: "🏝 Travel"),
        Category(name: "🐶 Pets"),
        Category(name: "🤷 Miscellaneous")
    ]
    
    let incomesCategories: [Category] = [
        Category(name: "👔 Salary"),
        Category(name: "💼 Business"),
        Category(name: "💸 Other")
    ]
    
    let accounts: [Category] = [
        Category(name: "💳 Credit Card"),
        Category(name: "💵 Cash")
    ]
}

