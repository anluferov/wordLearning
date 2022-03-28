//
//  WordCard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct WordCard: View {
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false

    var body: some View {
        ZStack {
            WordCardBack()
                .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 1, z: 0))
            WordCardFront()
                .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 1, z: 0))
        }
        .onTapGesture {
            flipCard ()
        }
    }
    
    func flipCard () {
        isFlipped = !isFlipped
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
        WordCard()
            .frame(width: 300.0, height: 300.0)
    }
}
