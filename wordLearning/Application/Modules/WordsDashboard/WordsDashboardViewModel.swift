//
//  WordsDashboardViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/11/22.
//

import Foundation

class WordsDashboardViewModel: ObservableObject {
    
    @Published var dataSource: [WordCardTopic]
    
    private let wordsService: WordsServiceProtocol = WordsService()
    
    init() {
        _dataSource = .init(initialValue: [])
    }
    
    func loadAvaliableTopics() {
        dataSource = Array(Set(wordsService.fetch().map { $0.topic }))
    }
}
