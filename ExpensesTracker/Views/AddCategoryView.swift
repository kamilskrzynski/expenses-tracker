//
//  AddCategoryView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 14/06/2022.
//

import SwiftUI
import Combine

class EmojiTextField: UITextField {
    override var textInputMode: UITextInputMode? {
        .activeInputModes.first(where: { $0.primaryLanguage == "emoji" })
    }
}

struct AddCategoryView: View {
    
    @StateObject private var vm = CategoriesViewModel()
    @Environment(\.dismiss) var dismiss

    let category: Categories
    let textLimit = 10
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                ZStack {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(width: 100, height: 100)
                        
                    TextField("", text: $vm.emoji)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 50))
                            .onReceive(Just(vm.emoji)) { _ in limitText(textLimit) }

                    }
                
                TextField("Enter \(category.rawValue) Name", text: $vm.categoryName)
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
        .navigationTitle("New \(category.rawValue)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.add(category: category)
                    dismiss()
                } label: {
                    Text("Done")
                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .medium))
                }
                .disabled(vm.categoryName.isEmpty)
                .opacity(vm.categoryName.isEmpty ? 0.5 : 1.0)
            }
        }
    }
    
    /// Function to keep text length in limits
    func limitText(_ upper: Int) {
        if vm.emoji.count > upper {
            vm.emoji = String(vm.emoji.prefix(upper))
        }
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(category: .Account)
    }
}
