//
//  MainView.swift
//  ExpensesTracker
//
//  Created by Kamil Skrzyński on 06/06/2022.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ListView()
                .tabItem {
                    Image(selectedTab == 0 ? "List-Active" : "List")
                        .resizable()
                        .frame(width: 1, height: 1)
                }
                .tag(0)
            InsightsView()
                .tabItem {
                Image(selectedTab == 1 ? "Insights-Active" : "Insights")
                        .resizable()
                        .frame(width: 1, height: 1)
            }
                .tag(1)
            SettingsView()
                .tabItem {
                    Image(selectedTab == 2 ? "Settings-Active" : "Settings")
                        .resizable()
                        .frame(width: 0.01, height: 0.01)
                        .aspectRatio(contentMode: .fit)
                }
                .tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
