//
//  TabBarViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/26/22.
//

import Foundation
import Combine

class TabBarViewModel: ObservableObject {
    enum State {
        case mainNonActiveTask
        case mainActiveTask
        case statictic
        case account
    }
    
    enum TabBarItem: String {
        case main
        case statistic
        case account
    }
    
    @Published var isTabBarShown: Bool = true
    @Published var selectedTabBarItem: TabBarItem = .main
    
    private var state = CurrentValueSubject<State, Never>(.mainNonActiveTask)
    
    private var cancelable: [AnyCancellable] = []
    
    init() {
        state.eraseToAnyPublisher()
            .sink { [unowned self] newState in
                switch newState {
                case .mainNonActiveTask:
                    self.isTabBarShown = true
                    self.selectedTabBarItem = .main
                case .mainActiveTask:
                    self.isTabBarShown = false
                    self.selectedTabBarItem = .main
                case .account:
                    self.isTabBarShown = true
                    self.selectedTabBarItem = .account
                case .statictic:
                    self.isTabBarShown = true
                    self.selectedTabBarItem = .statistic
                }
            }
            .store(in: &cancelable)
    }
    
    func updateTabAction(_ tabBarItem: TabBarItem) {
        switch tabBarItem {
        case .main:
            state.value = .mainNonActiveTask
        case .statistic:
            state.value = .statictic
        case .account:
            state.value = .account
        }
    }
    
    func appearTaskContainerAction() {
        state.value = .mainActiveTask
    }
    
    func disappearTaskContainerAction() {
        state.value = .mainNonActiveTask
    }
}
