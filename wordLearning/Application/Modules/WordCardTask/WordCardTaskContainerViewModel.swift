//
//  WordCardTaskViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/13/22.
//

import SwiftUI
import Combine

class WordCardTaskContainerViewModel: ObservableObject {
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    @ServiceDependency private(set) var userService: UserServiceProtocol
    
    enum State {
        case inactive
        case active
    }
    
    @Published var state: State = .inactive
    @Published var taskMode: WordCardTaskMode = .rememberForgot
    
    var matchedGeometryEffectId: String = ""
    
    private var cancelable: [AnyCancellable] = []
    
    init() {
        userService.currentTaskMode
            .sink(receiveValue: { currentTaskMode in
                self.taskMode = currentTaskMode
            })
            .store(in: &cancelable)
    }
    
    func startTask(with topic: WordCardTopic) {
        matchedGeometryEffectId = topic.rawValue
        state = .active
    }
    
    func finishTask() {
        state = .inactive
    }
}

