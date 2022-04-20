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
    
    var frontViewModel: NewWordCardFrontViewModel
    var backViewModel: NewWordCardBackViewModel
    
    @Published var isFlipped: Bool
    @Published var state: State
    @Published var backgroundOpacity: Double
    
    @Published var color: Color
    @Published var nextColor: Color

    let cardSide: Double = 300.0
    
    private let colors: [Color] = [.white, .orange, .red, .green, .blue]
    
    private var dragToCenterProgress: Double = 0.0
    
    init() {
        frontViewModel = NewWordCardFrontViewModel()
        backViewModel = NewWordCardBackViewModel()
        
        _isFlipped = .init(initialValue: false)
        _backgroundOpacity = .init(initialValue: 0.0)
        _state = .init(initialValue: .inactive)
        
        _color = .init(initialValue: colors[0])
        _nextColor = .init(initialValue: colors[1])
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
    
    func selectNextColorAction() {
        color = calculateNextColor()
        nextColor = calculateNextColor()
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
        let currentColorIndex = colors.firstIndex(of: color) ?? 0
        let nextColorIndex = (currentColorIndex + 1) % colors.count
        return colors[nextColorIndex]
    }
    
    private func updateFrontViewModel() {
        frontViewModel.hintOpacity = max(0.0, (1.0 - 4 * dragToCenterProgress))
        frontViewModel.topConfigurationBlurRadius = (20 - 4 * (dragToCenterProgress * 20.0))
    }
}
