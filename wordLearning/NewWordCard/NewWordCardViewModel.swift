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
    
    @Published var state: State
    @Published var backgroundOpacity: Double

    let cardSide: Double = 300.0
    
    private var dragToCenterProgress: Double = 0.0
    
    init() {
        frontViewModel = NewWordCardFrontViewModel()
        
        _backgroundOpacity = .init(initialValue: 0.0)
        _state = .init(initialValue: .inactive)
    }
    
    func dragGestureChanged(_ dragValue: DragGesture.Value, offset: Double) {
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
            dragToCenterProgress = min(1.0, Double(abs(dragGestureYOffset)) / offset)
        } else if dragGestureYOffset > 0 && (state == .dragToInactive) {
            dragToCenterProgress = max(0.0, 1.0 - Double(dragGestureYOffset) / offset)
        }
        
        backgroundOpacity = dragToCenterProgress
        
        updateFrontViewModel()
    }
    
    func dragGestureEnded() {
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
    
    func changeStep(previous: Bool = false) {
        switch state {
        case .inactive:
            state = previous ? .inactive : .dragToActive
        case .dragToActive:
            state = previous ? .inactive : .activeFront
        case .dragToInactive:
            state = previous ? .activeFront : .inactive
        case .activeFront:
            state = previous ? .dragToInactive : .activeBack
        case .activeBack:
            state = previous ? .activeFront : .saving
        case .saving:
            state = .inactive
        }
    }
    
    
    func updateFrontViewModel() {
        frontViewModel.hintOpacity = max(0.0, (1.0 - 4 * dragToCenterProgress))
        frontViewModel.topActionsBlurRadius = (20 - 4 * (dragToCenterProgress * 20.0))
    }
}

class NewWordCardFrontViewModel: ObservableObject {
    let colors: [Color] = [.white, .orange, .red, .gray, .green, .blue]
    
    @Published var hintOpacity: Double
    @Published var topActionsBlurRadius: Double

    @Published var currentColor: Color
    @Published var nextColor: Color
    
    init() {
        _hintOpacity = .init(initialValue: 1.0)
        _topActionsBlurRadius = .init(initialValue: 20.0)
        _currentColor = .init(initialValue: colors[0])
        _nextColor = .init(initialValue: colors[1])
    }
    
    func selectNextColor() {
        currentColor = calculateNextColor()
        nextColor = calculateNextColor()
    }
    
    private func calculateNextColor() -> Color {
        let currentColorIndex = colors.firstIndex(of: currentColor) ?? 0
        let nextColorIndex = (currentColorIndex + 1) % colors.count
        return colors[nextColorIndex]
    }
}
