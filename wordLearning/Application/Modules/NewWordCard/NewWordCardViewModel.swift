//
//  NewWordCardViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import Foundation
import SwiftUI

class NewWordCardViewModel: ObservableObject {
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    
    enum State {
        case inactive
        case dragToActive
        case dragToInactive
        case activeFront
        case activeBack
        case saving
    }
    
    @Published var state: State = .inactive
    @Published var isFlipped: Bool = false
    
    //TODO: Add Constants struct
    @Published var backgroundOpacity: Double = 0.0
    @Published var hintOpacity: Double = 1.0
    @Published var topConfigurationBlurRadius: Double = 20.0
    
    @Published var nextAvaliableColor: Color = WordCardColors[1]
    @Published var wordCard: WordCard = WordCard()
    
    let cardSide: Double = 300.0
    let nativeTextPlaceholder: String = "Enter word to learn"
    let toLearnTextPlaceholder: String = "Enter word to learn"
    
    private var dragToCenterProgress: Double = 0.0
    
    func dragGestureChangedAction(_ dragValue: DragGesture.Value, fullDragDistance: Double) {
        guard state != .activeBack else {
            return
        }
        
        switch state {
        case .inactive:
            state = .dragToActive
        case .activeFront:
            state = .dragToInactive
        default:
            break
        }
        
        let dragGestureYOffset = dragValue.translation.height
        
        if dragGestureYOffset < 0 && (state == .dragToActive) {
            dragToCenterProgress = min(1.0, Double(abs(dragGestureYOffset)) / fullDragDistance)
        } else if dragGestureYOffset > 0 && (state == .dragToInactive) {
            dragToCenterProgress = max(0.0, 1.0 - Double(dragGestureYOffset) / fullDragDistance)
        }
        
        backgroundOpacity = dragToCenterProgress
        
        updateFrontViewModel()
    }
    
    func dragGestureEndedAction() {
        let needChangeToPreviousStep: Bool = ((dragToCenterProgress != 1) && (state == .dragToActive)) || ((dragToCenterProgress != 0) && (state == .dragToInactive))
        switch state {
        case .dragToActive:
            state = needChangeToPreviousStep ? .inactive : .activeFront
        case .dragToInactive:
            state = needChangeToPreviousStep ? .activeFront : .inactive
        default:
            break
        }
    }
    
    func updateColorToNextAvaliable() {
        wordCard.color = calculateNextColor()
        nextAvaliableColor = calculateNextColor()
    }
    
    func updateToLearnLanguageAction(_ toLearnLanguage: String) {
        wordCard.toLearnWord.languageCode = toLearnLanguage
    }
    
    func updateNativeLanguageAction(_ nativeLanguage: String) {
        wordCard.nativeWord.languageCode = nativeLanguage
    }
    
    func updateTopicAction(_ topic: WordCardTopic) {
        wordCard.topic = topic
    }
    
    func flipForwardButtonAction() {
        isFlipped = true
        state = .activeBack
    }
    
    func flipBackButtonAction() {
        isFlipped = false
        state = .activeFront
    }
    
    func saveButtonAction() {
        state = .saving
        resetCardToDefaultData()
        
        wordCardService.create(wordCard)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isFlipped = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.state = .inactive
        }
    }
    
    private func calculateNextColor() -> Color {
        let currentColorIndex = WordCardColors.firstIndex(of: wordCard.color) ?? 0
        let nextColorIndex = (currentColorIndex + 1) % WordCardColors.count
        return WordCardColors[nextColorIndex]
    }
    
    private func updateFrontViewModel() {
        hintOpacity = max(0.0, (1.0 - 4 * dragToCenterProgress))
        topConfigurationBlurRadius = (20 - 4 * (dragToCenterProgress * 20.0))
    }
    
    private func resetCardToDefaultData() {
        backgroundOpacity = 0.0
        hintOpacity = 1.0
        topConfigurationBlurRadius = 20.0
        
        wordCard.toLearnWord.text = ""
        wordCard.nativeWord.text = ""
    }
}
