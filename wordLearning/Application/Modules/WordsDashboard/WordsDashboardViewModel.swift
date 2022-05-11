//
//  WordsDashboardViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/11/22.
//

import Foundation
import Combine

class WordsDashboardViewModel: ObservableObject {
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    
    @Published var dataSource: [WordCardsStack] = []
    @Published var needToShowDashboardPlaceholder: Bool = false
    
    private var cancelable: [AnyCancellable] = []
    
    init() {
        wordCardService.allWordsPublisher
            .map { allWords -> [WordCardsStack] in
                return allWords.map { $0.topic }
                .duplicateRemoved()
                .map { topic -> WordCardsStack in
                    let topicsWords: [WordCard] = allWords.filter { $0.topic == topic }
                    let color = topicsWords.first?.color ?? .white
                    let description = topicsWords.first?.topic.rawValue ?? ""
                    let isStack = (topicsWords.count > 1)
                    return WordCardsStack(isStack: isStack, color: color, description: description)
                }
            }
            .sink { [unowned self] values in
                self.needToShowDashboardPlaceholder = values.isEmpty
                self.dataSource = values
            }
            .store(in: &cancelable)
    }
    
    func loadAvaliableTopics() {
        wordCardService.fetch()
    }
}
