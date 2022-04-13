//
//  WordCard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct RotatableWordCardView<FrontContent: View, BackContent: View>: View {
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    
    private let frontContent: () -> FrontContent
    private let backContent: () -> BackContent
    
    init(@ViewBuilder frontContent: @escaping () -> FrontContent,
         @ViewBuilder backContent: @escaping () -> BackContent) {
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
        .onTapGesture {
            flipCard()
        }
    }
    
    func flipCard () {
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
            frontContent: {
                NewWordCardFront(viewModel: NewWordCardFrontViewModel.init())
            }, backContent: {
                NewWordCardBack()
            })
            .frame(width: 300.0, height: 300.0)
    }
}
