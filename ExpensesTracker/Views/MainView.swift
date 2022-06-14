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
                        .tabViewImageStyle()
                }
                .tag(0)
            InsightsView()
                .tabItem {
                Image(selectedTab == 1 ? "Insights-Active" : "Insights")
                        .tabViewImageStyle()
            }
                .tag(1)
            SettingsView()
                .tabItem {
                    Image(selectedTab == 2 ? "Settings-Active" : "Settings")
                        .tabViewImageStyle()
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
