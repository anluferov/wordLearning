//
//  NewWordCardViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import Foundation
import SwiftUI

class NewWordCardViewModel: ObservableObject {
    enum State {
        case inactive
        case dragToActive
        case dragToInactive
        case activeFront
        case activeBack
        case saving
    }
    
    @Published var state: State
    @Published var isFlipped: Bool
    
    @Published var backgroundOpacity: Double
    @Published var hintOpacity: Double
    @Published var topConfigurationBlurRadius: Double
    
    @Published var currentColor: Color
    @Published var nextAvaliableColor: Color
    @Published var topic: WordCardTopic?
    @Published var nativeLanguage: String
    @Published var toLearnLanguage: String
    @Published var nativeText: String
    @Published var toLearnText: String
    
    let cardSide: Double = 300.0
    
    let nativeTextPlaceholder: String = "Enter word to learn"
    let toLearnTextPlaceholder: String = "Enter word to learn"
    let topicPlaceholder: String = "Choose topic"
    
    let languages: [String] = ["English", "Russian", "Belarusian", "French", "German"]
    let topics: [WordCardTopic] = WordCardTopic.allCases
    private let colors: [Color] = [.white, .orange, .red, .green, .blue]
    
    private var dragToCenterProgress: Double = 0.0
    
    init() {
        _state = .init(initialValue: .inactive)
        _isFlipped = .init(initialValue: false)
        
        _backgroundOpacity = .init(initialValue: 0.0)
        _hintOpacity = .init(initialValue: 1.0)
        _topConfigurationBlurRadius = .init(initialValue: 20.0)
        
        _currentColor = .init(initialValue: colors[0])
        _nextAvaliableColor = .init(initialValue: colors[1])

        _topic = .init(initialValue: nil)
        _toLearnLanguage = .init(initialValue: languages.first ?? "")
        _nativeLanguage = .init(initialValue: languages.first ?? "")
        _toLearnText = .init(initialValue: "")
        _nativeText = .init(initialValue: "")
    }
    
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
        currentColor = calculateNextColor()
        nextAvaliableColor = calculateNextColor()
    }
    
    func updateToLearnLanguageAction(_ toLearnLanguage: String) {
        self.toLearnLanguage = toLearnLanguage
    }
    
    func updateNativeLanguageAction(_ nativeLanguage: String) {
        self.nativeLanguage = nativeLanguage
    }
    
    func updateTopicAction(_ topic: WordCardTopic) {
        self.topic = topic
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
        
    }
    
    private func calculateNextColor() -> Color {
        let currentColorIndex = colors.firstIndex(of: currentColor) ?? 0
        let nextColorIndex = (currentColorIndex + 1) % colors.count
        return colors[nextColorIndex]
    }
    
    private func updateFrontViewModel() {
        hintOpacity = max(0.0, (1.0 - 4 * dragToCenterProgress))
        topConfigurationBlurRadius = (20 - 4 * (dragToCenterProgress * 20.0))
    }
}
