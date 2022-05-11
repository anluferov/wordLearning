//
//  WordsService.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import Combine
import Foundation
import SwiftUI

//TODO: Debug implementation of service. Need to rewrite to CoreData or other
class WordCardService: WordCardServiceProtocol {
    var allWordsPublisher: AnyPublisher<[WordCard], Never> { allWords.eraseToAnyPublisher() }
    private let allWords = CurrentValueSubject<[WordCard], Never>([])
    
    func create(_ word: WordCard) {
        allWords.value.insert(word, at: 0)
    }
    
    func update(_ word: WordCard) {
        guard let updatedWordIndex = allWords.value.firstIndex(where: { $0.id == word.id }) else {
            return
        }
        
        allWords.value[updatedWordIndex] = word
    }
    
    func delete(_ word: WordCard) {
        guard let deletedWordIndex = allWords.value.firstIndex(where: { $0.id == word.id }) else {
            return
        }
        
        allWords.value.remove(at: deletedWordIndex)
    }
    
    func fetch() {
        allWords.value = []
    }
}
