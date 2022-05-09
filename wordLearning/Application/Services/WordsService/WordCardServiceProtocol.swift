//
//  WordCardServiceProtocol.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/9/22.
//

import Foundation

protocol WordCardServiceProtocol {
    func create(_ word: WordCard)
    func update(_ word: WordCard)
    func delete(_ word: WordCard)
    func fetch() -> [WordCard]
}
