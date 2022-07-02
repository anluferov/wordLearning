//
//  WordCardTaskViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/13/22.
//

import SwiftUI
import Combine

final class WordCardTaskContainerViewModel: ObservableObject {
    struct Constants {
        static let loadingTaskDuration: Double = 0.4
        static let wordCheckColorDuration: Double = 0.4
        static let backAnimationDuration: Double = 0.2
    }
    
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    @ServiceDependency private(set) var userService: UserServiceProtocol
    
    enum State {
        case inactive
        case loadingTask
        case activeTask
        case activeWordCheckSuccess
        case activeWordCheckFailed
    }
    
    var matchedGeometryEffectId: String = ""
    var activeTaskViewModel: WordTaskViewModel?
    
    @Published var taskMode: WordCardTaskMode = .rememberForgot
    @Published var containerColor: Color = .white
    @Published var isActiveTaskShown = false
    @Published var isContainerShown = false
    
    private var state = CurrentValueSubject<State, Never>(.inactive)
    
    private var cancelable: [AnyCancellable] = []
    
    init() {
        state.eraseToAnyPublisher()
            .combineLatest(userService.currentTaskMode)
            .sink(receiveValue: { [unowned self] (newState, currentTaskMode) in
                self.taskMode = currentTaskMode
                switch newState {
                case .inactive:
                    self.containerColor = .white
                    self.isActiveTaskShown = false
                    self.isContainerShown = false
                case .loadingTask:
                    self.containerColor = .white
                    self.isActiveTaskShown = false
                    self.isContainerShown = true
                case .activeTask:
                    self.containerColor = .white
                    self.isActiveTaskShown = true
                    self.isContainerShown = true
                case .activeWordCheckSuccess:
                    self.containerColor = .green
                    self.isActiveTaskShown = true
                    self.isContainerShown = true
                case .activeWordCheckFailed:
                    self.containerColor = .red
                    self.isActiveTaskShown = true
                    self.isContainerShown = true
                }
            })
            .store(in: &cancelable)
    }
}

extension WordCardTaskContainerViewModel {
    func appearAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadingTaskDuration) {
            self.state.value = .activeTask
            self.observeActiveTask()
        }
    }
    
    func disappearAction() {
        finishTaskAction()
    }
    
    func startTaskAction(_ topic: WordCardTopic) {
        matchedGeometryEffectId = topic.rawValue
        activeTaskViewModel = RememberForgotTaskViewModel(selectedTopic: topic)
        state.value = .loadingTask
    }
    
    func finishTaskAction() {
        matchedGeometryEffectId = ""
        activeTaskViewModel = nil
        state.value = .inactive
    }
}

private extension WordCardTaskContainerViewModel {
    func observeActiveTask() {
        guard let activeTask = activeTaskViewModel else {
            return
        }
        
        activeTask.isActiveTaskFinishedPublisher
            .combineLatest(activeTask.isWordCheckSuccessedPublisher)
            .sink { [weak self] (isActiveTaskFinished, isWordCheckSuccessed) in
                if isActiveTaskFinished {
                    self?.state.value = .inactive
                } else if let successed = isWordCheckSuccessed {
                    self?.state.value = successed ? .activeWordCheckSuccess : .activeWordCheckFailed
                } else {
                    self?.state.value = .activeTask
                }
            }
            .store(in: &cancelable)
    }
}

