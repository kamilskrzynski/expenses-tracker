//
//  AddExpenseView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 07/06/2022.
//

import SwiftUI

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
    
    var body: some View {
        NavigationView {
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
                        
                    } label: {
                        Text("Today")
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
                        
                    } label: {
                        Text("💳 Credit Card")
                            .foregroundColor(.primary)
                            .font(.system(size: 16, weight: .medium))
                    }
                    Image(systemName: "arrow.right")
                        .foregroundColor(.secondary)
                        .font(.system(size: 13, weight: .medium))
                    Spacer()
                        .frame(width: 30)
                    Button {
                        
                    } label: {
                        Text("☕️ Coffee")
                            .foregroundColor(.primary)
                            .font(.system(size: 16, weight: .medium))
                    }
                    Spacer()
                    Button {} label: {
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
        }
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
        default:
            break
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}
