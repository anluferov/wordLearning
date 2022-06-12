//
//  WordCardTaskViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/13/22.
//

import SwiftUI
import Combine

class WordCardTaskContainerViewModel: ObservableObject {
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    
    enum State {
        case inactive
        case active
    }
    
    @Published var state: State = .inactive
    var matchedGeometryEffectId: String = ""
    
    func startTask(with topic: WordCardTopic) {
        matchedGeometryEffectId = topic.rawValue
        state = .active
    }
    
    func finishTask() {
        state = .inactive
    }
}

