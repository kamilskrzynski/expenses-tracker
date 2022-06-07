//
//  ListView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 06/06/2022.
//

import SwiftUI

struct ListView: View {
    
    @State var expenses = []
    @State private var isSheetShowed: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if expenses.isEmpty {
                    Spacer()
                    Image("Drag")
                    Spacer()
                    Spacer()

                } else {
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                            .font(.system(size: 24, weight: .regular))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isSheetShowed = true
                    } label: {
                      Image(systemName: "plus.circle.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 24, weight: .regular))
                    }
                }
            }
            .fullScreenCover(isPresented: $isSheetShowed) {
                AddExpenseView()
        }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
