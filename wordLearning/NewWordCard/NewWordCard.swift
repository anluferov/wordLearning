//
//  CreationWordCardView.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/28/22.
//

import SwiftUI

struct NewWordCard: View {
    @ObservedObject private(set) var viewModel: NewWordCardViewModel
    
    var namespace: Namespace.ID
    
    @GestureState private var dragValue: CGSize = .zero
    
    var body: some View {
        ZStack {
            background
            movableNewCard
        }
    }
    
    var background: some View {
        Color(.black)
            .allowsHitTesting(false)
            .ignoresSafeArea()
            .opacity(viewModel.backgroundOpacity)
    }
    
    var movableNewCard: some View {
        GeometryReader { geometryProxy in
            VStack {
                HStack() {
                    RotatableWordCardView(
                        frontContent: {
                            NewWordCardFront(viewModel: viewModel.frontViewModel)
                        }, backContent: {
                            NewWordCardBack()
                        })
                        .matchedGeometryEffect(id: "wordCard", in: namespace)
                        .frame(width: viewModel.cardSide, height: viewModel.cardSide)
                        .animation(.spring(), value: dragValue)
                        .offset(dragValue)
                        .gesture(
                            DragGesture()
                                .updating($dragValue) { value, dragValueState, transaction in
                                    dragValueState.height = value.translation.height
                                }
                                .onChanged {
                                    let distance = Double(geometryProxy.size.height/2)
                                    viewModel.dragGestureChanged($0, offset: distance)
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        viewModel.dragGestureEnded()
                                    }
                                }
                        )
                        .offset(y: cardYOffset(geometryProxy))
                        
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    func cardYOffset(_ proxy: GeometryProxy) -> CGFloat {
        switch viewModel.state {
        case .inactive, .dragToActive:
            let notHiddenCardSideTopOffset: CGFloat = 30.0
            return (proxy.size.height/2 + viewModel.cardSide/2) - notHiddenCardSideTopOffset
        case .activeFront, .activeBack, .dragToInactive:
            return 0.0
        default:
            return 0.0
        }
    }
}

struct CreationWordCardView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        NewWordCard(viewModel: NewWordCardViewModel.init(), namespace: namespace)
    }
}
