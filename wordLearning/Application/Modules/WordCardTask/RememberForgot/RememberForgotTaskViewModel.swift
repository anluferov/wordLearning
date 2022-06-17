//
//  RememberForgotTaskViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/12/22.
//

import Foundation

protocol WordCardTaskViewModel {
    func prepareTaskData()
}

class RememberForgotTaskViewModel: ObservableObject, WordCardTaskViewModel {
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    
    @Published var currentWordCard: WordCard?
    @Published var currentWordCardIndex: Int = 0
    @Published var isCurrentWordCardFlipped: Bool = false
    
    private var selectedTopic: WordCardTopic
    private var dataSource: [WordCard] = []
    
    init(selectedTopic: WordCardTopic) {
        self.selectedTopic = selectedTopic
    }
    
    func prepareTaskData() {
        _ = wordCardService.allWords
            .sink(receiveValue: { [weak self] allWords in
                guard let self = self else { return }
                
                self.dataSource = allWords.filter { $0.topic == self.selectedTopic }
                self.currentWordCard = self.dataSource[safe: self.currentWordCardIndex]
            })
    }
    
    func rememberAction() {
        // TODO: convert into pipeline
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nextCardAction()
        }
    }
    
    func forgotAction() {
        isCurrentWordCardFlipped.toggle()
    }
    
    func nextCardAction() {
        currentWordCardIndex += 1
        currentWordCard = dataSource[safe: currentWordCardIndex]
        isCurrentWordCardFlipped.toggle()
    }
}
