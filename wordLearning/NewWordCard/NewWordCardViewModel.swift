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
    
    func dragGestureChanged(_ dragValue: DragGesture.Value, fullDragDistance: Double) {
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
    
    private func updateFrontViewModel() {
        frontViewModel.hintOpacity = max(0.0, (1.0 - 4 * dragToCenterProgress))
        frontViewModel.topActionsBlurRadius = (20 - 4 * (dragToCenterProgress * 20.0))
    }
}
