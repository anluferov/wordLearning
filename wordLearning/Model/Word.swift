//
//  Word.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import Foundation

struct Word {
    let id: String
    let text: String
    let languageCode: String
    
    init(text: String, languageCode: String) {
        self.id = UUID().uuidString
        self.text = text
        self.languageCode = languageCode
    }
}
