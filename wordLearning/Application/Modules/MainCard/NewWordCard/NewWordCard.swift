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
                HStack {
                    if viewModel.isCardShown {
                        RotatableView(
                            isFlipped: $viewModel.isCardFlipped,
                            frontContent: {
                                NewWordCardFront()
                            }, backContent: {
                                NewWordCardBack()
                            }
                        )
                        .matchedGeometryEffect(id: viewModel.matchedGeometryEffectId, in: namespace, isSource: false)
                        .frame(width: NewWordCardViewModel.Constants.cardSide, height: NewWordCardViewModel.Constants.cardSide)
                        .animation(.spring(), value: dragValue)
                        .offset(dragValue)
                        .gesture(
                            DragGesture()
                                .updating($dragValue) { value, dragValueState, transaction in
                                    dragValueState.height = value.translation.height
                                }
                                .onChanged {
                                    viewModel.dragGestureChangedAction($0)
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        viewModel.dragGestureEndedAction()
                                    }
                                }
                        )
                        .offset(y: viewModel.cardYOffset)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
            .onAppear {
                viewModel.appearInContainerAction(geometryProxy)
            }
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
