//
//  WordCard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import Foundation
import SwiftUI

//TODO: rewrite in more beauty way
let WordCardColors: [Color] = [.white, .orange, .red, .green, .blue]
let WordCardLanguageCodes: [String] = ["eng", "rus", "blr", "fr", "ger"]

struct WordCard: Equatable, Identifiable {
    var id = UUID()
    var nativeWord: Word = Word(languageCode: "rus")
    var toLearnWord: Word = Word(languageCode: "eng")
    var topic: WordCardTopic = WordCardTopic.home
    var color: Color = WordCardColors[0]
    
    static func == (lhs: WordCard, rhs: WordCard) -> Bool {
        lhs.id == rhs.id
    }
}
