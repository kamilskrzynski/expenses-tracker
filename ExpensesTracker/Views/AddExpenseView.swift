//
//  AddExpenseView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 07/06/2022.
//

import SwiftUI

enum CustomSheet {
    case accounts
    case expenses
}

struct AddExpenseView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var number = "0"
    
    @Namespace private var animation
    let keyboardButton: [[KeyboardNumber]] = [
        [.seven, .eight, .nine],
        [.four, .five, .six],
        [.one, .two, .three],
        [.comma, .zero, .backspace]
    ]
    
    @AppStorage("firstTime") var firstTime: Bool = false
    @State private var accountTypeButtonClicked: Bool = false
    @State private var expenseTypeButtonClicked: Bool = false
    @State private var datePickerClicked: Bool = false
    @State var selectedAccount: Category = Category(emoji: "💳", name: "Credit Card")
    @State var selectedExpense: Category = Category(emoji: "☕️", name: "Coffee")
    @StateObject private var vm = CategoriesViewModel()
    @State var selectedDate: Date = Date()
    @State var createNewIncome: Bool = false
    @State var createNewExpense: Bool = false
    @State var createNewAccount: Bool = false
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack {
                    Spacer()
                    HStack {
                        Text(number)
                            .foregroundColor(.primary)
                            .font(.system(size: 80, weight: .regular))
                        VStack {
                            
                            Text("zł")
                                .foregroundColor(.primary.opacity(0.5))
                                .font(.system(size: 40, weight: .regular))
                            Spacer()
                        }
                    }
                    .matchedGeometryEffect(id: "Timeline", in: animation, isSource: true)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1)
                            .frame(height: 3)
                            .foregroundColor(.secondary)
                            .matchedGeometryEffect(id: "Timeline", in: animation, isSource: false)
                    )
                    .frame(height: 80)
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                datePickerClicked = true
                            }
                        } label: {
                            Text(selectedDateString)
                                .foregroundColor(.secondary)
                                .font(.system(size: 15, weight: .medium))
                        }
                        Image(systemName: "circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 1))
                        Text("Unlock notes")
                            .foregroundColor(.secondary.opacity(0.7))
                            .font(.system(size: 15, weight: .medium))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    HStack {
                        Button {
                            withAnimation {
                                self.accountTypeButtonClicked = true
                            }
                        } label: {
                            Text(selectedAccount.emoji + " " + selectedAccount.name)
                                .foregroundColor(.primary)
                                .font(.system(size: 16, weight: .medium))
                        }
                        Image(systemName: "arrow.right")
                            .foregroundColor(.secondary)
                            .font(.system(size: 13, weight: .medium))
                        Spacer()
                            .frame(width: 30)
                        Button {
                            withAnimation {
                                self.expenseTypeButtonClicked = true
                            }
                        } label: {
                            Text(selectedExpense.emoji + " " + selectedExpense.name)
                                .foregroundColor(.primary)
                                .font(.system(size: 16, weight: .medium))
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Save")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.invertedPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.primary))
                    }
                    .padding(.horizontal)
                    Divider()
                    Spacer()
                        .frame(height: 30)
                    keyboard
                }
                .onTapGesture {
                    withAnimation {
                        self.datePickerClicked = false
                    }
                }
                .navigationTitle("Expense")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                if datePickerClicked {
                    VStack {
                        Spacer()
                        datePicker
                    }
                    .background(self.datePickerClicked ? Color.black.opacity(0.3) : Color.clear)
                }
                
                if accountTypeButtonClicked {
                    VStack {
                        Spacer()
                        accounts
                            .offset(y: self.accountTypeButtonClicked ? 0 : UIScreen.main.bounds.height)
                    }
                    .background(self.accountTypeButtonClicked ? Color.black.opacity(0.3) : Color.clear)
                    .onTapGesture {
                        withAnimation {
                            self.accountTypeButtonClicked = false
                        }
                    }
                }
                if expenseTypeButtonClicked {
                    VStack {
                        Spacer()
                        expenses
                            .offset(y: self.expenseTypeButtonClicked ? 0 : UIScreen.main.bounds.height)
                        
                    }
                    .background(self.expenseTypeButtonClicked ? Color.black.opacity(0.3) : Color.clear)
                    .onTapGesture {
                        withAnimation {
                            self.expenseTypeButtonClicked = false
                        }
                    }
                }
            }
        }
        .onAppear {
            print(selectedDateString)
            if !firstTime {
                vm.saveInitialAccounts()
                vm.saveInitialIncomes()
                vm.saveInitialExpenses()
                firstTime = true
                print(UserDefaults.standard.bool(forKey: "firstTime"))
            }
        }
    }
    
    var datePicker: some View {
        VStack {
            DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.graphical)
                .accentColor(.gray)
                .offset(y: self.datePickerClicked ? 0 : UIScreen.main.bounds.height)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height / 2.6)
        .padding(.top, 10)
        .background(Color.customSheetBackground)
        .cornerRadius(25)
        .padding(.horizontal, 5)
    }
    
    var expenses: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer()
                    .frame(height: 20)
                Text("EXPENSES")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15, weight: .semibold))
                LazyVGrid(columns: columns) {
                    ForEach(vm.getExpenses(), id: \.self) { expense in
                        Button {
                            selectedExpense = expense
                            expenseTypeButtonClicked = false
                        } label: {
                            VStack {
                                Text(expense.emoji)
                                    .font(.system(size: 30))
                                Text(expense.name)
                                    .lineLimit(1)
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .frame(width: 80, height: 80)
                            .foregroundColor(.secondary)
                        }
                    }
                    SheetAddButton(action: createNewIncome = true)
                }
                Text("INCOMES")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15, weight: .semibold))
                LazyVGrid(columns: columns) {
                    ForEach(vm.getIncomes(), id: \.self) { income in
                        Button {
                            selectedExpense = income
                            expenseTypeButtonClicked = false
                        } label: {
                            VStack {
                                Text(income.emoji)
                                    .font(.system(size: 30))
                                Text(income.name)
                                    .lineLimit(1)
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .frame(width: 80, height: 80)
                            .foregroundColor(.secondary)
                        }
                    }
                    
                    SheetAddButton(action: createNewExpense = true)
                }
                Text("ACCOUNTS")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15, weight: .semibold))
                LazyVGrid(columns: columns) {
                    ForEach(vm.getAccounts(), id: \.self) { account in
                        Button {
                            selectedAccount = account
                            expenseTypeButtonClicked = false
                        } label: {
                            VStack {
                                Text(account.emoji)
                                    .font(.system(size: 30))
                                Text(account.name)
                                    .lineLimit(1)
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .frame(width: 80, height: 80)
                            .foregroundColor(.secondary)
                        }
                    }
                    SheetAddButton(action: createNewAccount = true)
                }
                
                Spacer()
                    .frame(height: 20)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height / 2)
        .background(Color.customSheetBackground)
        .cornerRadius(25)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .padding(.horizontal, 5)
    }
    
    var accounts: some View {
        VStack(spacing: 20) {
            Text("ACCOUNTS")
                .foregroundColor(.secondary)
                .font(.system(size: 15, weight: .semibold))
            LazyVGrid(columns: columns) {
                ForEach(vm.getAccounts(), id: \.self) { account in
                    Button {
                        selectedAccount = account
                        accountTypeButtonClicked = false
                    } label: {
                        VStack {
                            Text(account.emoji)
                                .font(.system(size: 30))
                            Text(account.name)
                                .lineLimit(1)
                                .font(.system(size: 15, weight: .medium))
                        }
                        .frame(width: 80, height: 80)
                        .foregroundColor(.secondary)
                    }
                }
                SheetAddButton(action: createNewAccount = true)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(Color.customSheetBackground)
        .cornerRadius(25)
        .padding(.top, 20)
        .padding(.bottom, 20)
        .padding(.horizontal, 5)
    }
    
    var keyboard: some View {
        VStack(spacing: 20) {
            ForEach(keyboardButton, id: \.self) { row in
                HStack(spacing: 70) {
                    ForEach(row, id: \.self) { button in
                        if button.rawValue == "delete.backward" {
                            Button {
                                buttonTapped(button: button)
                            } label: {
                                Image(systemName: button.rawValue)
                                    .font(.system(size: 25, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(CustomButtonStyle())
                        } else if button.rawValue == "," {
                            Button {
                                buttonTapped(button: button)
                            } label: {
                                Text(button.rawValue)
                                    .font(.system(size: 30, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(CustomButtonStyle())
                        } else {
                            Button {
                                buttonTapped(button: button)
                            } label: {
                                Text(button.rawValue)
                                    .font(.system(size: 30, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    func buttonTapped(button: KeyboardNumber) {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            if number == "0" {
                number = button.rawValue
            } else {
                number = number + button.rawValue
            }
        case .comma:
            number = number + button.rawValue
        case .backspace:
            number.removeLast()
            if number.isEmpty {
                number = "0"
            }
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}
