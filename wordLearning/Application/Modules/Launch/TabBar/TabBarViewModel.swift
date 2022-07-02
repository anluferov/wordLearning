//
//  TabBarViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/26/22.
//

import Foundation
import SwiftUI
import Combine

final class TabBarViewModel: ObservableObject {
    enum State {
        case mainNonActiveTask
        case mainActiveTask
        case account
    }
    
    enum TabBarItem {
        case main
        case account
    }
    
    @Published var isTabBardShown: Bool = true
    
    private var state = CurrentValueSubject<State, Never>(.mainNonActiveTask)
    
    private var cancelable: [AnyCancellable] = []
    
    init() {
        state.eraseToAnyPublisher()
            .sink { [unowned self] newState in
                switch newState {
                case .mainNonActiveTask:
                    self.isTabBardShown = true
                case .mainActiveTask:
                    self.isTabBardShown = false
                case .account:
                    self.isTabBardShown = true
                }
            }
            .store(in: &cancelable)
    }
}

extension TabBarViewModel {
    func updateTabAction(_ tabBarItem: TabBarItem) {
        switch tabBarItem {
        case .main:
            state.value = .mainNonActiveTask
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
