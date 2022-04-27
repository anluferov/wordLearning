//
//  WordCard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct RotatableWordCardView<FrontContent: View, BackContent: View>: View {
    @State private var frontContentDegree = 0.0
    @State private var backContentDegree = -90.0
    
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
                .rotation3DEffect(Angle(degrees: backContentDegree), axis: (x: 0, y: 1, z: 0))
                .allowsHitTesting(isFlipped)
            frontContent()
                .rotation3DEffect(Angle(degrees: frontContentDegree), axis: (x: 0, y: 1, z: 0))
                .allowsHitTesting(!isFlipped)
        }
        .onChange(of: isFlipped) { newValue in
            flipCard()
        }
    }
    
    func flipCard() {
        if isFlipped {
            withAnimation(.linear(duration: 2.0)) {
                frontContentDegree = 90
            }
            withAnimation(.linear(duration: 2.0).delay(2.0)){
                backContentDegree = 0
            }
        } else {
            withAnimation(.linear(duration: 2.0)) {
                backContentDegree = -90
            }
            withAnimation(.linear(duration: 2.0).delay(2.0)){
                frontContentDegree = 0
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
