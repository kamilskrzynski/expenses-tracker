//
//  ChartData.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 13/06/2022.
//

import Foundation

struct WeekChartData: Hashable {
    
    let day: String
    let amount: Double
}

struct MonthChartData: Hashable {
    
    let day: String
    let amount: Double
}

struct YearChartData: Hashable {
    
    let month: String
    let amount: Double
}
