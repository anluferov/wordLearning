//
//  WordCard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import Foundation
import SwiftUI

//TODO: rewrite in more beauty way

struct WordCard: Equatable, Hashable, Identifiable {
    var id = UUID()
    var nativeWord: Word = Word(languageCode: "rus")
    var toLearnWord: Word = Word(languageCode: "eng")
    var topic: WordCardTopic = WordCardTopic.home
    
    static func == (lhs: WordCard, rhs: WordCard) -> Bool {
        lhs.id == rhs.id
    }
}
