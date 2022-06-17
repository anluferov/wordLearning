//
//  WordCardTask.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/13/22.
//

import SwiftUI

struct WordCardTaskContainer: View {
    @EnvironmentObject var viewModel: WordCardTaskContainerViewModel
    
    @State var isTaskHidden = true
    
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        self.isTaskHidden = false
                    }
                }
            }
            .onDisappear {
                self.isTaskHidden = true
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
            
            if !isTaskHidden {
                switch viewModel.taskMode {
                case .rememberForgot:
                    RememberForgotTask(viewModel: RememberForgotTaskViewModel(selectedTopic: viewModel.top))
                        .transition(.move(edge: .bottom))
                case .writing:
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                        .frame(width: 200.0, height: 200.0)
                }
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
