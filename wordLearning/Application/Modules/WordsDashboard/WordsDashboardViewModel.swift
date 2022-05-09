//
//  WordsDashboardViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/11/22.
//

import Foundation

class WordsDashboardViewModel: ObservableObject {
    
    @Published var dataSource: [WordCardTopic]
    
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    
    init() {
        _dataSource = .init(initialValue: [])
    }
    
    func loadAvaliableTopics() {
        dataSource = Array(Set(wordCardService.fetch().map { $0.topic }))
    }
}
