//
//  WordsDashboardViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/11/22.
//

import Foundation
import Combine
import SwiftUI

class WordsDashboardViewModel: ObservableObject {
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    
    @Published var dataSource: [WordCardsStack] = []
    
    init() {
        wordCardService.allWords
            .map { allWords -> [WordCardsStack] in
                return allWords.map { $0.topic }
                .duplicateRemoved()
                .map { topic -> WordCardsStack in
                    let topicsWords: [WordCard] = allWords.filter { $0.topic == topic }
                    let color: Color = .white
                    let description = topicsWords.first?.topic.rawValue ?? ""
                    let hasSeveralCards = (topicsWords.count > 1)
                    return WordCardsStack(hasSeveralCards: hasSeveralCards, color: color, description: description, topic: topicsWords.first?.topic ?? .home)
                }
            }
            .assign(to: &$dataSource)
    }
    
    func loadAvaliableTopics() {
        wordCardService.fetch()
    }
}
