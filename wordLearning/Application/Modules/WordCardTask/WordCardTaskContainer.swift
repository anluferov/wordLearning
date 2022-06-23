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
        if viewModel.isContainerShown {
            ZStack {
                background
                activeCardTaskContainer
            }
            .onAppear {
                withAnimation {
                    viewModel.appearAction()
                }
            }
            .onDisappear {
                viewModel.disappearAction()
            }
        }
    }
    
    var background: some View {
        Color(.black)
            .allowsHitTesting(false)
            .ignoresSafeArea()
            .opacity(0.9)
    }
    
    var activeCardTaskContainer: some View {
        ZStack {
            Rectangle()
                .foregroundColor(viewModel.containerColor)
                .animation(.easeOut(duration: WordCardTaskContainerViewModel.Constants.backAnimationDuration), value: viewModel.containerColor)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                .matchedGeometryEffect(id: viewModel.matchedGeometryEffectId, in: namespace)
                .overlay(
                    activeCardTask
                )
                .clipped()
                .padding(30.0)
                .onTapGesture {
                    viewModel.finishTaskAction()
                }
        }
    }
    
    var activeCardTask: some View {
        ZStack {
            if viewModel.isActiveTaskShown {
                switch viewModel.taskMode {
                case .rememberForgot:
                    RememberForgotTask(viewModel: viewModel.activeTaskViewModel)
                        .onAppear {
                            viewModel.activeTaskViewModel?.startTaskAction()
                        }
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
