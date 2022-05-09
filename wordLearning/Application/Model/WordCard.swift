//
//  WordCard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import Foundation
import SwiftUI

struct WordCard {
    let id: String
    let nativeWord: Word
    let toLearnWord: Word
    let color: Color
    let topic: WordCardTopic
    
    init() {
        self.id = UUID().uuidString
        self.nativeWord = Word(text: "Слово \(id)", languageCode: "rus")
        self.toLearnWord = Word(text: "Word \(id)", languageCode: "eng")
        self.color = [Color.white, Color.orange, Color.red, Color.gray, Color.green, Color.blue].randomElement()!
        self.topic = WordCardTopic.allCases.randomElement()!
    }
}
