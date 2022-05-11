//
//  WordCardServiceProtocol.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/9/22.
//

import Foundation
import Combine

protocol WordCardServiceProtocol {
    var allWordsPublisher: AnyPublisher<[WordCard], Never> { get }
    
    func create(_ word: WordCard)
    func update(_ word: WordCard)
    func delete(_ word: WordCard)
    func fetch()
}
