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
    var allWords: AnyPublisher<[WordCard], Never> { _allWords.eraseToAnyPublisher() }
    private let _allWords = CurrentValueSubject<[WordCard], Never>([])
    
    func create(_ word: WordCard) {
        _allWords.value.insert(word, at: 0)
    }
    
    func update(_ word: WordCard) {
        guard let updatedWordIndex = _allWords.value.firstIndex(where: { $0.id == word.id }) else {
            return
        }
        
        _allWords.value[updatedWordIndex] = word
    }
    
    func delete(_ word: WordCard) {
        guard let deletedWordIndex = _allWords.value.firstIndex(where: { $0.id == word.id }) else {
            return
        }
        
        _allWords.value.remove(at: deletedWordIndex)
    }
    
    func fetch() {
//        _allWords.value = [WordCard()]
        
        let englishWords = [("perceptive", "проницательный"),
                            ("inspirational", "вдохновляющий"),
                            ("obstinate", "упрямый"),
                            ("conscientious", "добросовестный")]

        _allWords.value = englishWords.map { words in
            let nativeWord = Word(id: UUID(), text: words.0, languageCode: "en")
            let toLearnWord = Word(id: UUID(), text: words.1, languageCode: "rus")
            return WordCard(id: UUID(), nativeWord: nativeWord , toLearnWord: toLearnWord, topic: .home)
        }
    }
}
