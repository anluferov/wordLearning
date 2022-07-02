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
        TabView {
            VStack(spacing: 0.0) {
                MainCard()
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 0)
                    .background(viewModel.isTabBardShown ? .white : .clear)
            }
            .tabItem {
                if viewModel.isTabBardShown {
                    Label("Main", systemImage: "list.dash")
                        .onTapGesture {
                            viewModel.updateTabAction(.main)
                        }
                }
            }

            Color.yellow
                .ignoresSafeArea(.container, edges: .top)
                .tabItem {
                    if viewModel.isTabBardShown {
                        Label("Account", systemImage: "square.and.pencil")
                            .onTapGesture {
                                viewModel.updateTabAction(.account)
                            }
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
