//
//  WordsDashboardViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/11/22.
//

import Foundation

class WordsDashboardViewModel: ObservableObject {
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    
    @Published var dataSource: [WordCardTopic] = []
    
    init() {
        wordCardService.allWordsPublisher
            .map { $0.map { word in word.topic }.duplicateRemoved() }
            .assign(to: &$dataSource)
    }
    
    func loadAvaliableTopics() {
        wordCardService.fetch()
    }
}
