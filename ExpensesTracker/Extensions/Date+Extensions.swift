//
//  Date+Extensions.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 10/06/2022.
//

import SwiftUI

extension Date {
    func startOfWeek() -> Date {
        
        var calendar = Calendar(identifier: .iso8601)
        let timezone = TimeZone(secondsFromGMT: 0)!
        calendar.timeZone = timezone
        return calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    func startOfNextWeek(using calendar: Calendar = .iso8601) -> Date {
        calendar.date(byAdding: .day, value: 7, to: self.startOfWeek())!
    }
    
    func getNextDays(using calendar: Calendar = .iso8601, dayAmount: Int) -> Date {
        calendar.date(byAdding: .day, value: dayAmount, to: self.startOfWeek())!
    }
    
    func endOfWeek(using calendar: Calendar = .iso8601) -> Date {
        calendar.date(byAdding: .second, value: -1, to: startOfNextWeek())!
    }
    
    func dayNumberOfWeek() -> Int? {
        if Calendar.current.dateComponents([.weekday], from: self).weekday == 0 {
            return 7
        } else {
            return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
        }
    }
}
