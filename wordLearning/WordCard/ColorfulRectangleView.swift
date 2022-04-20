//
//  ColorfulView.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/3/22.
//

import Foundation
import SwiftUI

struct ColorfulRectangleView: View {
    @State private var currentColor: Color
    @State private var newColorProgress: (color: Color, progress: CGFloat)

    @ObservedObject var colorStore: ColorStore
    
    init(color: Color) {
        self._currentColor = State<Color>(initialValue: color)
        self._newColorProgress = State<(color: Color, progress: CGFloat)>(initialValue: (color: color, progress: 1.0))
        
        self.colorStore = ColorStore(color: color)
    }

    var body: some View {
        Rectangle()
            .foregroundColor(currentColor)
            .overlay(
                ColorfulShape(progress: newColorProgress.progress)
                    .foregroundColor(newColorProgress.color)
            )
            .onReceive(colorStore.$color) { color in
                newColorProgress = (color: color, progress: 0.0)
                withAnimation(.easeInOut(duration: 0.5)) {
                    newColorProgress.progress = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        currentColor = newColorProgress.color
                    }
                }
            }
    }
}

class ColorStore: ObservableObject {
    @Published var color: Color
    
    init(color: Color) {
        self.color = color
    }
}


struct ColorfulShape: Shape {
    
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { return progress }
        set { self.progress = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * progress))
        path.addLine(to: CGPoint(x: 0, y: rect.height * progress))
        path.closeSubpath()
        return path
    }
}
