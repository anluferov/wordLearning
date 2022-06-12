//
//  WordCardTask.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/13/22.
//

import SwiftUI

struct WordCardTaskContainer: View {
    @EnvironmentObject var viewModel: WordCardTaskContainerViewModel
    
    var namespace: Namespace.ID
    
    var body: some View {
        switch viewModel.state {
        case .inactive:
            EmptyView()
        case .active:
            ZStack {
                background
                cardTask
            }

        }
    }
    
    var background: some View {
        Color(.black)
            .allowsHitTesting(false)
            .ignoresSafeArea()
            .opacity(0.9)
    }
    
    var cardTask: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                .matchedGeometryEffect(id: viewModel.matchedGeometryEffectId, in: namespace)
                .padding(30.0)
                .onTapGesture {
                    viewModel.finishTask()
                }
        }
    }
}

struct WordCardTask_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        WordCardTaskContainer(namespace: namespace)
    }
}
