//
//  WordsDashboardViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/11/22.
//

import Foundation

class WordsDashboardViewModel: ObservableObject {
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    
    @Published var dataSource: [WordCardsStack] = []
    
    init() {
        wordCardService.allWordsPublisher
            .map { allWords in
                allWords.map { $0.topic }
                .duplicateRemoved()
                .compactMap { topic in
                    let topicsWords: [WordCard] = allWords.filter { $0.topic == topic }
                    let color = topicsWords.first?.color ?? .white
                    let description = topicsWords.first?.topic.rawValue ?? ""
                    let isStack = (topicsWords.count > 1)
                    return topicsWords.isEmpty ? nil : WordCardsStack(isStack: isStack, color: color, description: description)
                }
            }
            .assign(to: &$dataSource)
    }
    
    func loadAvaliableTopics() {
        wordCardService.fetch()
    }
}
