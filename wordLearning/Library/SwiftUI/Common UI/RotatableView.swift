//
//  WordCard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

fileprivate struct Constants {
    static let frontOnTopFrontContentDegree: Double = 0.0
    static let frontOnTopBackContentDegree: Double = -90.0
    static let backOnTopFrontContentDegree: Double = 90.0
    static let backOnTopBackContentDegree: Double = 0.0
    static let rotationAnimationDuration: Double = 0.4
}

struct RotatableView<FrontContent: View, BackContent: View>: View {
    @State private var frontContentDegree = Constants.frontOnTopFrontContentDegree
    @State private var backContentDegree = Constants.frontOnTopBackContentDegree
    
    @Binding var isFlipped: Bool
    @Binding var animated: Bool
    
    private let frontContent: () -> FrontContent
    private let backContent: () -> BackContent
    
    init(isFlipped: Binding<Bool>,
         animated: Binding<Bool> = .constant(true),
         @ViewBuilder frontContent: @escaping () -> FrontContent,
         @ViewBuilder backContent: @escaping () -> BackContent) {
        self._isFlipped = isFlipped
        self._animated = animated
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
        let animationDuration = animated ? Constants.rotationAnimationDuration : 0.0
        withAnimation(.linear(duration: animationDuration).delay(isFlipped ? 0.0 : animationDuration)) {
            frontContentDegree = isFlipped ? Constants.backOnTopFrontContentDegree : Constants.frontOnTopFrontContentDegree
        }
        withAnimation(.linear(duration: animationDuration).delay(isFlipped ? animationDuration : 0.0)) {
            backContentDegree = isFlipped ? Constants.backOnTopBackContentDegree : Constants.frontOnTopBackContentDegree
        }
    }
}

struct WordCard_Previews: PreviewProvider {
    static var previews: some View {
        RotatableView(
            isFlipped: .constant(false),
            frontContent: {
                NewWordCardFront()
            }, backContent: {
                NewWordCardBack()
            })
            .frame(width: 300.0, height: 300.0)
    }
}
