//
//  WordsService.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import Combine
import Foundation
import SwiftUI

protocol WordsServiceProtocol {
    func create(_ word: WordCard)
    func update(_ word: WordCard)
    func delete(_ word: WordCard)
    func fetch() -> [WordCard]
}

//TODO: Debug implementation of service. Need to rewrite to CoreData or other
class WordsService: WordsServiceProtocol {
    private var allWords: [WordCard] = [WordCard(), WordCard(), WordCard(), WordCard(), WordCard(), WordCard()]
    
    func create(_ word: WordCard) {
        allWords.append(word)
    }
    
    func update(_ word: WordCard) {
        guard let updatedWordIndex = allWords.firstIndex(where: { $0.id == word.id }) else {
            return
        }
        
        allWords[updatedWordIndex] = word
    }
    
    func delete(_ word: WordCard) {
        guard let deletedWordIndex = allWords.firstIndex(where: { $0.id == word.id }) else {
            return
        }
        
        allWords.remove(at: deletedWordIndex)
    }
    
    func fetch() -> [WordCard] {
        allWords
    }
}
