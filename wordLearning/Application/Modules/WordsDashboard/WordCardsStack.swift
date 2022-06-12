//
//  WordCardsStack.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/9/22.
//

import Foundation
import SwiftUI

let WordCardColors: [Color] = [.white, .orange, .red, .green, .blue]

struct WordCardsStack: Hashable {
    var hasSeveralCards: Bool
    var color: Color
    var description: String
    var topic: WordCardTopic
}
