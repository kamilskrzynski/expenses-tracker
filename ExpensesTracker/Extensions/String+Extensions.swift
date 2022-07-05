//
//  String+Extensions.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 05/07/2022.
//

import SwiftUI

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
