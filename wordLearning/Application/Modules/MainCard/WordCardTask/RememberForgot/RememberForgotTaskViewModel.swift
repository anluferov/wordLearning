//
//  RememberForgotTaskViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/12/22.
//

import Foundation
import SwiftUI
import Combine

final class RememberForgotTaskViewModel: ObservableObject, WordTaskViewModel {
    struct Constants {
        static let showingToLearnWordInterval: Double = 1.6
        static let hidingWordInterval: Double = 0.8
        static let changeOffsetDuration: Double = 0.4
    }
    
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    
    // states of RememberForgotTask module
    enum State {
        case inactive
        case centerNativeSide
        case centerToLearnRememberSide
        case centerToLearnForgotSide
        case topHidden
        case bottomHidden
    }
    
    // external WordTaskViewModel protocol property
    var isActiveTaskFinishedPublisher: AnyPublisher<Bool, Never> { isActiveTaskFinished.eraseToAnyPublisher() }
    private var isActiveTaskFinished = CurrentValueSubject<Bool, Never>(false)
    var isWordCheckSuccessedPublisher: AnyPublisher<Bool?, Never> { isWordCheckSuccessed.eraseToAnyPublisher() }
    private var isWordCheckSuccessed = CurrentValueSubject<Bool?, Never>(nil)
    
    // Published properties for RememberForgotTaskView observing
    @Published var offset: CGFloat = 0.0
    @Published var offsetAnimationDuration: CGFloat = 1.0
    @Published var opacity: CGFloat = 0.0
    @Published var currentWordCard: WordCard?
    @Published var isWordCardFlipped: Bool = false
    @Published var isFlippingAnimated: Bool = true
    
    private var state = CurrentValueSubject<State, Never>(.bottomHidden)
    private var currentWordCardIndex = CurrentValueSubject<Int, Never>(0)
    private var selectedTopic: WordCardTopic
    private var dataSource: [WordCard] = []
    
    private var cancelable: [AnyCancellable] = []
    
    init(selectedTopic: WordCardTopic) {
        self.selectedTopic = selectedTopic
        
        //TODO: check if all words pipelane really execute always before state / currentWordCardIndex pipeline
        _ = wordCardService.allWords
            .sink(receiveValue: { [weak self] allWords in
                guard let self = self else { return }
                
                self.dataSource = allWords.filter { $0.topic == self.selectedTopic }
            })
        
        state.eraseToAnyPublisher()
            .combineLatest(currentWordCardIndex.eraseToAnyPublisher())
            .sink { [unowned self] (newState, newCardIndex) in
                self.currentWordCard = self.dataSource[safe: newCardIndex]
                
                switch newState {
                case .inactive:
                    self.isWordCheckSuccessed.value = nil
                    self.isActiveTaskFinished.value = true
                case .centerNativeSide:
                    self.isWordCheckSuccessed.value = nil
                    self.offset = 0.0
                    self.offsetAnimationDuration = Constants.changeOffsetDuration
                    self.opacity = 1.0
                    self.isWordCardFlipped = false
                    self.isFlippingAnimated = false
                case .centerToLearnRememberSide:
                    self.isWordCheckSuccessed.value = true
                    self.offset = 0.0
                    self.offsetAnimationDuration = 0.0
                    self.opacity = 1.0
                    self.isWordCardFlipped = true
                    self.isFlippingAnimated = true
                case .centerToLearnForgotSide:
                    self.isWordCheckSuccessed.value = false
                    self.offset = 0.0
                    self.offsetAnimationDuration = 0.0
                    self.opacity = 1.0
                    self.isWordCardFlipped = true
                    self.isFlippingAnimated = true
                case .topHidden:
                    self.isWordCheckSuccessed.value = nil
                    self.offset = -((UIScreen.main.bounds.height / 2) + 200.0)
                    self.offsetAnimationDuration = Constants.changeOffsetDuration
                    self.opacity = 1.0
                    self.isWordCardFlipped = true
                    self.isFlippingAnimated = false
                case .bottomHidden:
                    self.isWordCheckSuccessed.value = nil
                    self.offset = ((UIScreen.main.bounds.height / 2) + 200.0)
                    self.offsetAnimationDuration = 0.0
                    self.opacity = 1.0
                    self.isWordCardFlipped = false
                    self.isFlippingAnimated = false
                }
            }
            .store(in: &cancelable)
    }
}

extension RememberForgotTaskViewModel {
    func startTaskAction() {
        state.value = .centerNativeSide
    }
    
    func finishTaskAction() {
        state.value = .inactive
    }
    
    func rememberWordAction() {
        state.value = .centerToLearnRememberSide
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.showingToLearnWordInterval) {
            self.switchToNextCard()
        }
    }
    
    func forgotWordAction() {
        state.value = .centerToLearnForgotSide
    }
    
    func nextWordAction() {
        guard state.value != .centerToLearnRememberSide else {
            return
        }
        
        switchToNextCard()
    }
}

private extension RememberForgotTaskViewModel {
    func switchToNextCard() {
        state.value = .topHidden
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.hidingWordInterval / 2) {
            self.currentWordCardIndex.value += 1
            self.state.value = (self.currentWordCardIndex.value > (self.dataSource.count - 1)) ? .inactive : .bottomHidden
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.hidingWordInterval) {
            self.state.value = .centerNativeSide
        }
    }
}
