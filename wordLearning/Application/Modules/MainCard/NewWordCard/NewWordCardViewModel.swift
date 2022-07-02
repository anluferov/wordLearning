//
//  NewWordCardViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/2/22.
//

import SwiftUI
import Combine

final class NewWordCardViewModel: ObservableObject {
    struct Constants {
        static let notHiddenCardSideTopOffset: CGFloat = 40.0
        static let cardSide: CGFloat = 300.0
        static let nativeTextPlaceholder: String = "Enter word to learn"
        static let toLearnTextPlaceholder: String = "Enter native word"
    }
    
    @ServiceDependency private(set) var wordCardService: WordCardServiceProtocol
    @ServiceDependency private(set) var userService: UserServiceProtocol
    
    enum State: Equatable {
        case inactive
        case dragToActive(Double)
        case dragToInactive(Double)
        case activeFront
        case activeBack
        case saving
    }
    
    var matchedGeometryEffectId: String { wordCard.topic.rawValue }
    var selectedWordTopic: WordCardTopic { wordCard.topic }
    
    @Published var nativeText: String = ""
    @Published var toLearnText: String = ""

    @Published var isCardFlipped: Bool = false
    @Published var isCardShown: Bool = true
    @Published var cardYOffset: CGFloat = 0.0
    @Published var backgroundOpacity: Double = 0.0
    @Published var hintOpacity: Double = 1.0
    @Published var topConfigurationBlurRadius: Double = 20.0
    
    private var state = CurrentValueSubject<State, Never>(.inactive)
    private var geometryProxy: GeometryProxy?
    private var wordCard: WordCard = WordCard()
    private var fullCardDragDistance: CGFloat {
        let containerSize = geometryProxy?.size ?? UIScreen.main.bounds.size
        return Double(containerSize.height/2)
    }
    
    private var cancelable: [AnyCancellable] = []
    
    init() {
        userService.currentNativeLanguage
            .combineLatest(userService.currentToLearnLanguage, $nativeText, $toLearnText) { (nativeLanguage, toLearnLanguage, nativeText, toLearnText) in
                return (nativeWord: Word(text: nativeText, languageCode: nativeLanguage), toLearnWord: Word(text: toLearnText, languageCode: toLearnLanguage))
            }
            .sink { [unowned self] wordDetails in
                self.wordCard = WordCard(nativeWord: wordDetails.nativeWord, toLearnWord: wordDetails.toLearnWord)
            }
            .store(in: &cancelable)
        
        $nativeText
            .combineLatest($toLearnText) { (nativeText, toLearnText) in
                return (nativeText, toLearnText)
            }
            .sink { (native, toLearn) in
                self.wordCard = WordCard(nativeWord: Word(languageCode: native), toLearnWord: Word(languageCode: toLearn))
            }
            .store(in: &cancelable)
        
        state.eraseToAnyPublisher()
            .sink(receiveValue: { [unowned self] newState in
                switch newState {
                case .inactive:
                    self.isCardFlipped = false
                    self.isCardShown = true
                    self.cardYOffset = (fullCardDragDistance + Constants.cardSide/2) - Constants.notHiddenCardSideTopOffset
                    self.backgroundOpacity = 0.0
                    self.hintOpacity = 1.0
                    self.topConfigurationBlurRadius = 20.0
                case .dragToActive(let dragProgress):
                    self.isCardFlipped = false
                    self.isCardShown = true
                    self.cardYOffset = (fullCardDragDistance + Constants.cardSide/2) - Constants.notHiddenCardSideTopOffset
                    self.backgroundOpacity = dragProgress
                    self.hintOpacity = max(0.0, (1.0 - 4 * dragProgress))
                    self.topConfigurationBlurRadius = (20 - 4 * (dragProgress * 20.0))
                case .dragToInactive(let dragProgress):
                    self.isCardFlipped = false
                    self.isCardShown = true
                    self.cardYOffset = 0.0
                    self.backgroundOpacity = dragProgress
                    self.hintOpacity = max(0.0, (1.0 - 4 * dragProgress))
                    self.topConfigurationBlurRadius = (20 - 4 * (dragProgress * 20.0))
                case .activeFront:
                    self.isCardFlipped = false
                    self.isCardShown = true
                    self.cardYOffset = 0.0
                    self.backgroundOpacity = 1.0
                    self.hintOpacity = 0.0
                    self.topConfigurationBlurRadius = 0.0
                case .activeBack:
                    self.isCardFlipped = true
                    self.isCardShown = true
                    self.cardYOffset = 0.0
                    self.backgroundOpacity = 1.0
                    self.hintOpacity = 0.0
                    self.topConfigurationBlurRadius = 0.0
                case .saving:
                    self.isCardFlipped = false
                    self.isCardShown = false
                    self.cardYOffset = 0.0
                    
                    self.backgroundOpacity = 0.0
                    self.hintOpacity = 1.0
                    self.topConfigurationBlurRadius = 20.0
                }
            })
            .store(in: &cancelable)
    }
}

extension NewWordCardViewModel {
    func appearInContainerAction(_ geometryProxy: GeometryProxy) {
        self.geometryProxy = geometryProxy
        state.value = .inactive
    }
    
    func dragGestureChangedAction(_ dragValue: DragGesture.Value) {
        guard state.value != .activeBack else {
            return
        }
        
        switch state.value {
        case .inactive, .dragToActive:
            let dragProgress = min(1.0, Double(abs(dragValue.translation.height)) / fullCardDragDistance)
            state.value = .dragToActive(dragProgress)
        case .activeFront, .dragToInactive:
            let dragProgress = max(0.0, 1.0 - Double(dragValue.translation.height) / fullCardDragDistance)
            state.value = .dragToInactive(dragProgress)
        default:
            break
        }
    }
    
    func dragGestureEndedAction() {
        switch state.value {
        case .dragToActive(let dragProgress):
            state.value = (dragProgress != 1.0) ? .inactive : .activeFront
        case .dragToInactive(let dragProgress):
            state.value = (dragProgress != 0.0) ? .activeFront : .inactive
        default:
            break
        }
    }
    
    func updateTopicAction(_ topic: WordCardTopic) {
        wordCard.topic = topic
    }
    
    func flipForwardButtonAction() {
        state.value = .activeBack
    }
    
    func flipBackButtonAction() {
        state.value = .activeFront
    }
    
    func saveButtonAction() {
        state.value = .saving
        
        wordCardService.create(wordCard)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.wordCard.toLearnWord.text = ""
            self?.wordCard.nativeWord.text = ""
            
            self?.state.value = .inactive
        }
    }
}
