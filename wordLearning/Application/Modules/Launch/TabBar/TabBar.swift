//
//  TabBar.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/26/22.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var viewModel: TabBarViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTabBarItem) {
            mainTab
                .tag(TabBarViewModel.TabBarItem.main)
            statisticsTab
                .tag(TabBarViewModel.TabBarItem.statistic)
            settingsTab
                .tag(TabBarViewModel.TabBarItem.account)
        }
        // TODO: need to understand how to set color of selected tab item
        // accentColor works but deprecated
//        .accentColor(.orange)
    }
    
    var mainTab: some View {
        VStack(spacing: 0.0) {
            MainCard()
            Rectangle()
                .fill(Color.clear)
                .frame(height: 0)
                .background(viewModel.isTabBarShown ? .white : .clear)
        }
        .tabItem {
            if viewModel.isTabBarShown {
                Label("Main", systemImage: "square")
                    .tint(.red)
                    .onTapGesture {
                        viewModel.updateTabAction(.main)
                    }
            }
        }
    }
    
    var statisticsTab: some View {
        Statistics()
            .tabItem {
                if viewModel.isTabBarShown {
                    Label("Statistic", systemImage: "chart.pie")
                        .onTapGesture {
                            viewModel.updateTabAction(.statistic)
                        }
                }
            }
    }
    
    var settingsTab: some View {
        Settings()
            .tabItem {
                if viewModel.isTabBarShown {
                    Label("Settings", systemImage: "gear")
                        .onTapGesture {
                            viewModel.updateTabAction(.account)
                        }
                }
            }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
