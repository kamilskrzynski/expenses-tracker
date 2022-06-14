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
    @Namespace private var animation
    
    let keyboardButton: [[KeyboardNumber]] = [
        [.seven, .eight, .nine],
        [.four, .five, .six],
        [.one, .two, .three],
        [.comma, .zero, .backspace]
    ]
    
    @AppStorage("firstTime") var firstTime: Bool = false
    @StateObject private var vm = CategoriesViewModel()
    @State var createNewIncome: Bool = false
    @State var createNewExpense: Bool = false
    @State var createNewAccount: Bool = false
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack {
                    Spacer()
                    header
                    Spacer()
                    dateAndNotes
                    Divider()
                    accountsAndSaveButton
                    Divider()
                    Spacer()
                        .frame(height: 30)
                    keyboard
                }
                .onTapGesture {
                    withAnimation {
                        vm.datePickerClicked = false
                    }
                }
                .navigationTitle("Expense")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        toolbarButton
                    }
                }
                
                /// Shows custom DatePicker modal
                if vm.datePickerClicked {
                    VStack {
                        Spacer()
                        /// This rectangle is to dismiss DatePicker
                        /// While trying to dismiss like other Custom Modal Sheets, DatePicker doesn't save new date
                        Rectangle()
                            .foregroundColor(Color.black.opacity(0.01))
                            .frame(height: UIScreen.main.bounds.height / 2.6)
                            .onTapGesture {
                                withAnimation {
                                    vm.datePickerClicked = false
                                }
                            }
                        datePicker
                    }
                    .background(vm.datePickerClicked ? Color.black.opacity(0.3) : Color.clear)
                }
                
                /// Shows account modal
                if vm.accountTypeButtonClicked {
                    VStack {
                        Spacer()
                        accounts
                            .offset(y: vm.accountTypeButtonClicked ? 0 : UIScreen.main.bounds.height)
                    }
                    .background(vm.accountTypeButtonClicked ? Color.black.opacity(0.3) : Color.clear)
                    .onTapGesture {
                        withAnimation {
                            vm.accountTypeButtonClicked = false
                        }
                    }
                }
                
                /// Shows expenses modal
                if vm.expenseTypeButtonClicked {
                    VStack {
                        Spacer()
                        expenses
                            .offset(y: vm.expenseTypeButtonClicked ? 0 : UIScreen.main.bounds.height)
                        
                    }
                    .background(vm.expenseTypeButtonClicked ? Color.black.opacity(0.3) : Color.clear)
                    .onTapGesture {
                        withAnimation {
                            vm.expenseTypeButtonClicked = false
                        }
                    }
                }
            }
        }
        .onAppear {
            /// Used to create initial categories
            if !firstTime {
                vm.saveInitialAccounts()
                vm.saveInitialIncomes()
                vm.saveInitialExpenses()
                firstTime = true
            }
        }
    }
    
    // MARK: Toolbar Button
    var toolbarButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Cancel")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: Date and notes
    var dateAndNotes: some View {
        HStack {
            Button {
                withAnimation {
                    vm.datePickerClicked = true
                }
            } label: {
                Text(vm.selectedDateString)
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
    }
    
    // MARK: Accounts and Save Button
    var accountsAndSaveButton: some View {
        HStack {
            Button {
                withAnimation {
                    vm.accountTypeButtonClicked = true
                }
            } label: {
                Text(vm.selectedAccount.emoji + " " + vm.selectedAccount.name)
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
                    vm.expenseTypeButtonClicked = true
                }
            } label: {
                Text(vm.selectedExpense.emoji + " " + vm.selectedExpense.name)
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .medium))
            }
            Spacer()
            Button {
                vm.createExpense()
                dismiss()
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
    }
    
    // MARK: Header
    var header: some View {
        HStack {
            Text(vm.amount)
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
    }
    
    // MARK: DatePicker Modal
    var datePicker: some View {
        VStack {
            DatePicker("", selection: $vm.selectedDate, in: ...Date(), displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.graphical)
                .accentColor(.gray)
                .offset(y: vm.datePickerClicked ? 0 : UIScreen.main.bounds.height)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height / 2.6)
        .padding(.top, 10)
        .background(Color.customSheetBackground)
        .cornerRadius(25)
        .padding(.horizontal, 5)
    }
    
    // MARK: Expenses Modal
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
                            withAnimation {
                                vm.selectedExpense = expense
                                vm.selectedType = "expense"
                                vm.expenseTypeButtonClicked = false
                            }
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
                    Button {
                        createNewExpense = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 21, weight: .semibold))
                            .foregroundColor(.secondary)
                            .background(Circle().frame(width: 60, height: 60).foregroundColor(.gray.opacity(0.3)))
                    }
                    .fullScreenCover(isPresented: $createNewExpense) {
                        NavigationView {
                            AddCategoryView(category: Categories.Expense)
                        }
                    }
                }
                Text("INCOMES")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15, weight: .semibold))
                LazyVGrid(columns: columns) {
                    ForEach(vm.getIncomes(), id: \.self) { income in
                        Button {
                            withAnimation {
                                vm.selectedExpense = income
                                vm.selectedType = "income"
                                vm.expenseTypeButtonClicked = false
                            }
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
                    
                    Button {
                        createNewIncome = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 21, weight: .semibold))
                            .foregroundColor(.secondary)
                            .background(Circle().frame(width: 60, height: 60).foregroundColor(.gray.opacity(0.3)))
                    }
                    .fullScreenCover(isPresented: $createNewIncome) {
                        NavigationView {
                            AddCategoryView(category: Categories.Income)
                        }
                    }

                }
                Text("ACCOUNTS")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15, weight: .semibold))
                LazyVGrid(columns: columns) {
                    ForEach(vm.getAccounts(), id: \.self) { account in
                        Button {
                            withAnimation {
                                vm.selectedAccount = account
                                vm.expenseTypeButtonClicked = false
                            }
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
                    Button {
                        createNewAccount = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 21, weight: .semibold))
                            .foregroundColor(.secondary)
                            .background(Circle().frame(width: 60, height: 60).foregroundColor(.gray.opacity(0.3)))
                    }
                    .fullScreenCover(isPresented: $createNewAccount) {
                        NavigationView {
                            AddCategoryView(category: Categories.Account)
                        }
                    }
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
    
    // MARK: Accounts Modal
    var accounts: some View {
        VStack(spacing: 20) {
            Text("ACCOUNTS")
                .foregroundColor(.secondary)
                .font(.system(size: 15, weight: .semibold))
            LazyVGrid(columns: columns) {
                ForEach(vm.getAccounts(), id: \.self) { account in
                    Button {
                        withAnimation {
                            vm.selectedAccount = account
                            vm.accountTypeButtonClicked = false
                        }
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
                Button {
                    createNewAccount = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundColor(.secondary)
                        .background(Circle().frame(width: 60, height: 60).foregroundColor(.gray.opacity(0.3)))
                }
                .fullScreenCover(isPresented: $createNewAccount) {
                    NavigationView {
                        AddCategoryView(category: Categories.Account)
                    }
                }
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
    
    // MARK: Custom keyboard
    var keyboard: some View {
        VStack(spacing: 20) {
            ForEach(keyboardButton, id: \.self) { row in
                HStack(spacing: 70) {
                    ForEach(row, id: \.self) { button in
                        if button.rawValue == "delete.backward" {
                            Button {
                                DispatchQueue.main.async {
                                    vm.buttonTapped(button: button)
                                }
                            } label: {
                                Image(systemName: button.rawValue)
                                    .font(.system(size: 25, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(CustomButtonStyle())
                        } else if button.rawValue == "," {
                            Button {
                                DispatchQueue.main.async {
                                    vm.buttonTapped(button: button)
                                }
                            } label: {
                                Text(button.rawValue)
                                    .font(.system(size: 30, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(CustomButtonStyle())
                        } else {
                            Button {
                                DispatchQueue.main.async {
                                    vm.buttonTapped(button: button)
                                }
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
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}
