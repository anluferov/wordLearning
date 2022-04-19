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
        let a: CGFloat = rect.height
        let b: CGFloat = rect.width

        let c = pow(pow(a, 2) + pow(b, 2), 0.5) // a^2 + b^2 = c^2  --> Solved for 'c'
        let radius = c * progress

        var path = Path()
        path.addArc(center: CGPoint(x: 35.0, y: 35.0),
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        return path
    }
}
