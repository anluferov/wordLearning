//
//  NewWordCardFrontViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/19/22.
//

import Foundation
import SwiftUI

class NewWordCardFrontViewModel: ObservableObject {
    @Published var hintOpacity: Double
    @Published var topConfigurationBlurRadius: Double
    
    @Published var currentLanguage: String
    @Published var currentTopic: WordCardTopic?
    
    @Published var toLearnText: String
    
    let toLearnTextPlaceholder: String = "Enter word to learn"
    let topicPlaceholder: String = "Choose topic"
    
    let languages: [String] = ["English", "Russian", "Belarusian", "French", "German"]
    let topics: [WordCardTopic] = WordCardTopic.allCases
    private let colors: [Color] = [.white, .orange, .red, .green, .blue]
    
    init() {
        _hintOpacity = .init(initialValue: 1.0)
        _topConfigurationBlurRadius = .init(initialValue: 20.0)

        _currentLanguage = .init(initialValue: languages.first ?? "")
        _currentTopic = .init(initialValue: nil)

        
        _toLearnText = .init(initialValue: "")
    }
    
    func selectLanguageAction(_ language: String) {
        currentLanguage = language
    }
    
    func selectTopicAction(_ topic: WordCardTopic) {
        currentTopic = topic
    }
}
