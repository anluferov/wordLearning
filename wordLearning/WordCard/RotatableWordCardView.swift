//
//  WordCard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct RotatableWordCardView<FrontContent: View, BackContent: View>: View {
    @State private var backDegree = 0.0
    @State private var frontDegree = -90.0
    
    @Binding var isFlipped: Bool
    
    private let frontContent: () -> FrontContent
    private let backContent: () -> BackContent
    
    init(isFlipped: Binding<Bool>,
         @ViewBuilder frontContent: @escaping () -> FrontContent,
         @ViewBuilder backContent: @escaping () -> BackContent) {
        self._isFlipped = isFlipped
        self.frontContent = frontContent
        self.backContent = backContent
    }

    var body: some View {
        ZStack {
            backContent()
                .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 1, z: 0))
            frontContent()
                .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 1, z: 0))
        }
        .onChange(of: isFlipped) { newValue in
            flipCard()
        }
    }
    
    func flipCard() {
        isFlipped.toggle()
        if isFlipped {
            withAnimation(.linear(duration: 0.3)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: 0.3).delay(0.3)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: 0.3)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: 0.3).delay(0.3)){
                backDegree = 0
            }
        }
    }
}

struct WordCard_Previews: PreviewProvider {
    static var previews: some View {
        RotatableWordCardView(
            isFlipped: .constant(false),
            frontContent: {
                NewWordCardFront()
            }, backContent: {
                NewWordCardBack()
            })
            .frame(width: 300.0, height: 300.0)
    }
}
