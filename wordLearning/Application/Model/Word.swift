//
//  Word.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import Foundation

struct Word: Identifiable, Hashable {
    var id: UUID = UUID()
    var text: String = ""
    var languageCode: String
    
    init(languageCode: String) {
        self.languageCode = languageCode
    }
}
