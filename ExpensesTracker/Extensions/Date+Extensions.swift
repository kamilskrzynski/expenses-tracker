//
//  Date+Extensions.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 10/06/2022.
//

import SwiftUI

extension Date {
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
            calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
        }
}
