//
//  CreationWordCardView.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/28/22.
//

import SwiftUI

struct CreationWordCardView: View {
    
    var namespace: Namespace.ID
    
    var cardSide: CGFloat = 300.0
    
    @Binding var dragToCenterProgress: Double
    
    @GestureState private var dragValue: CGSize = .zero
    @State private var isCreationActive: Bool = false
    
    var body: some View {
        GeometryReader{ geometryProxy in
            VStack {
                HStack() {
                    WordCard()
                        .matchedGeometryEffect(id: "wordCard", in: namespace)
                        .frame(width: cardSide, height: cardSide)
                        .animation(.spring(), value: dragValue)
                        .offset(dragValue)
                        .gesture(
                            DragGesture()
                                .updating($dragValue) { value, dragValueState, transaction in
                                    dragValueState.height = value.translation.height
                                }
                                .onChanged {
                                    dragGestureChanged($0, proxy: geometryProxy)
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        dragToCenterProgress = isCreationActive ? 1.0 : 0.0
                                    }
                                }
                        )
                        .offset(y: isCreationActive ? 0.0 : defaultCardYOffset(geometryProxy))
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    func dragGestureChanged(_ dragValue: DragGesture.Value, proxy: GeometryProxy) {
        let dragGestureYOffset = dragValue.translation.height
        
        //TODO: dragToCenterProgress updated not as expected: after 0.99 we get 0.7 value. Investigate
        if dragGestureYOffset < 0 && !isCreationActive {
            dragToCenterProgress = min(1.0, Double(abs(dragGestureYOffset)) / Double(proxy.size.height/2))
        } else if dragGestureYOffset > 0 && isCreationActive {
            dragToCenterProgress = max(0.0, 1.0 - Double(dragGestureYOffset) / Double(proxy.size.height/2))
        }

        if dragToCenterProgress == 1.0 {
            isCreationActive = true
        } else if dragToCenterProgress == 0.0 {
            isCreationActive = false
        }
    }
    
    func defaultCardYOffset(_ proxy: GeometryProxy) -> CGFloat {
        let notHiddenCardSideTopOffset: CGFloat = 30.0
        return (proxy.size.height/2 + cardSide/2) - notHiddenCardSideTopOffset
    }
}

struct CreationWordCardView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        CreationWordCardView(namespace: namespace, dragToCenterProgress: .constant(0.0))
    }
}
