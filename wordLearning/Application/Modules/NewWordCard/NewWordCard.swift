//
//  CreationWordCardView.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/28/22.
//

import SwiftUI

struct NewWordCard: View {
    @EnvironmentObject var viewModel: NewWordCardViewModel
    
    @GestureState private var dragValue: CGSize = .zero
    var namespace: Namespace.ID
    
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
                    if viewModel.state != .saving {
                        RotatableView(
                            isFlipped: $viewModel.isFlipped,
                            frontContent: {
                                NewWordCardFront()
                            }, backContent: {
                                NewWordCardBack()
                            }
                        )
                        .matchedGeometryEffect(id: viewModel.wordCard.topic.rawValue, in: namespace, isSource: false)
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
                                    viewModel.dragGestureChangedAction($0, fullDragDistance: distance)
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        viewModel.dragGestureEndedAction()
                                    }
                                }
                        )
                        .offset(y: cardYOffset(geometryProxy))
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
            .environmentObject(viewModel)
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
        NewWordCard(namespace: namespace)
            .environmentObject(NewWordCardViewModel.init())
    }
}
