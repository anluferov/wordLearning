//
//  NewWordCardBackViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/20/22.
//

import Foundation
import SwiftUI

class NewWordCardBackViewModel: ObservableObject {
    @Published var nativeLanguage: String
    @Published var nativeText: String
    
    let nativeTextPlaceholder: String = "Enter word to learn"
    
    let languages: [String] = ["English", "Russian", "Belarusian", "French", "German"]
    
    init() {
        _nativeLanguage = .init(initialValue: languages.first ?? "")
        _nativeText = .init(initialValue: "")
    }
    
    func saveCardButtonAction() {
        
    }
}
