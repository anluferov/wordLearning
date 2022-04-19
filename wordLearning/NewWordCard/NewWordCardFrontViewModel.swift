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
    @Published var topActionsBlurRadius: Double

    @Published var currentColor: Color
    @Published var nextColor: Color
    
    @Published var toLearnText: String
    
    private let colors: [Color] = [.white, .orange, .red, .gray, .green, .blue]
    
    init() {
        _hintOpacity = .init(initialValue: 1.0)
        _topActionsBlurRadius = .init(initialValue: 20.0)
        _currentColor = .init(initialValue: colors[0])
        _nextColor = .init(initialValue: colors[1])
        _toLearnText = .init(initialValue: "")
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
