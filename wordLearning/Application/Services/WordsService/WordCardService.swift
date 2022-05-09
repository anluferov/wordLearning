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
    var allWordsPublisher: Published<[WordCard]>.Publisher { $allWords }
    @Published private var allWords: [WordCard] = []
    
    func create(_ word: WordCard) {
        allWords.insert(word, at: 0)
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
    
    func fetch() {
        allWords = [WordCard()]
    }
}
