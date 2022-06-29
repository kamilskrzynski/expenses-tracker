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
    
    func startOfLastWeek(using calendar: Calendar = .iso8601) -> Date {
        calendar.date(byAdding: .day, value: -7, to: self.startOfWeek())!
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
    
    func dayNumberOfMonth() -> Int? {
        return Calendar.current.dateComponents([.day], from: self).day!
    }
    
    func monthNumberOfYear() -> Int? {
        return Calendar.current.dateComponents([.month], from: self).month!
    }
    
    func startOfMonth() -> Date {
        
        var calendar = Calendar(identifier: .iso8601)
        let timezone = TimeZone(secondsFromGMT: 0)!
        calendar.timeZone = timezone
        return calendar.dateComponents([.calendar, .year, .month], from: self).date!
    }
    
    func startOfYear() -> Date {
        
        var calendar = Calendar(identifier: .iso8601)
        let timezone = TimeZone(secondsFromGMT: 0)!
        calendar.timeZone = timezone
        return calendar.dateComponents([.calendar, .year], from: self).date!
    }
    
    func getNextDaysOfMonth(using calendar: Calendar = .iso8601, dayAmount: Int) -> Date {
        calendar.date(byAdding: .day, value: dayAmount, to: self.startOfMonth())!
    }
    
    func getNextMonths(using calendar: Calendar = .iso8601, monthAmount: Int) -> Date {
        if monthAmount == 0 || monthAmount == 1 || monthAmount == 2 || monthAmount == 10 || monthAmount == 11 || monthAmount == 12 {
            return calendar.date(byAdding: .month, value: monthAmount, to: self.startOfYear())!
        } else {
            var dateComponents = DateComponents()
            dateComponents.month = monthAmount
            dateComponents.hour = 1
            return calendar.date(byAdding: dateComponents, to: self.startOfYear())!
        }
    }
    
    func startOfNextMonth(using calendar: Calendar = .iso8601) -> Date {
        calendar.date(byAdding: .month, value: 1, to: self.startOfMonth())!
    }
    
    func startOfNextYear(using calendar: Calendar = .iso8601) -> Date {
        calendar.date(byAdding: .year, value: 1, to: self.startOfYear())!
    }
    
    func startOfLastMonth(using calendar: Calendar = .iso8601) -> Date {
        calendar.date(byAdding: .month, value: -1, to: self.startOfMonth())!
    }
    
    func startOfLastYear(using calendar: Calendar = .iso8601) -> Date {
        calendar.date(byAdding: .year, value: -1, to: self.startOfYear())!
    }
}
