//
//  WordCardTask.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/13/22.
//

import SwiftUI

struct WordCardTaskContainer: View {
    @EnvironmentObject var taskContainerViewModel: WordCardTaskContainerViewModel
    @EnvironmentObject var tabBarViewModel: TabBarViewModel
    
    var namespace: Namespace.ID
    
    var body: some View {
        if taskContainerViewModel.isContainerShown {
            ZStack {
                background
                activeCardTaskContainer
            }
            .onAppear {
                withAnimation {
                    taskContainerViewModel.appearAction()
                    tabBarViewModel.appearTaskContainerAction()
                }
            }
            .onDisappear {
                taskContainerViewModel.disappearAction()
                tabBarViewModel.disappearTaskContainerAction()
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
                .foregroundColor(taskContainerViewModel.containerColor)
                .animation(.easeOut(duration: WordCardTaskContainerViewModel.Constants.backAnimationDuration), value: taskContainerViewModel.containerColor)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
            //TODO: fix geometry hero animation from dashboard to task container
//                .matchedGeometryEffect(id: viewModel.matchedGeometryEffectId, in: namespace)
                .overlay(
                    activeCardTask
                )
                .clipped()
                .padding(30.0)
                .overlay(closeButton, alignment: .topTrailing)
        }
    }
    
    var activeCardTask: some View {
        ZStack {
            if taskContainerViewModel.isActiveTaskShown {
                switch taskContainerViewModel.taskMode {
                case .rememberForgot:
                    RememberForgotTask(viewModel: taskContainerViewModel.activeTaskViewModel)
                        .onAppear {
                            taskContainerViewModel.activeTaskViewModel?.startTaskAction()
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
    
    var closeButton: some View {
        Button {
            taskContainerViewModel.activeTaskViewModel?.finishTaskAction()
            taskContainerViewModel.finishTaskAction()
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.black)
                .font(Font.title.weight(.bold))
                .frame(width: 20.0, height: 20.0)
                .padding(EdgeInsets(top: 30.0, leading: 0.0, bottom: 0.0, trailing: 30.0))
        }
        .padding()
    }
}

struct WordCardTask_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        WordCardTaskContainer(namespace: namespace)
    }
}
