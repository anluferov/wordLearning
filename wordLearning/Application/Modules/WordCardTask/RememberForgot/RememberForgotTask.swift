//
//  RememberForgotTask.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/12/22.
//

import SwiftUI

struct RememberForgotTask: View {
    @ObservedObject var taskViewModel: RememberForgotTaskViewModel
    
    init?(viewModel: WordTaskViewModel?) {
        guard let rememberForgotTaskViewModel = viewModel as? RememberForgotTaskViewModel else {
            return nil
        }
        
        self.taskViewModel = rememberForgotTaskViewModel
    }
    
    var body: some View {
        RotatableView(
            isFlipped: $taskViewModel.isWordCardFlipped,
            animated: $taskViewModel.isFlippingAnimated,
            frontContent: {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                    .overlay(
                        VStack {
                            Spacer()
                            Text(taskViewModel.currentWordCard?.nativeWord.text ?? "")
                                .font(.system(size: 23, weight: .black, design: .rounded))
                                .padding()
                            Spacer()
                            HStack {
                                rememberButton
                                Spacer()
                                forgotButton
                            }
                        }
                    )
                
            }, backContent: {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                    .overlay(
                        VStack {
                            Spacer()
                            Text(taskViewModel.currentWordCard?.toLearnWord.text ?? "")
                                .font(.system(size: 23, weight: .black, design: .rounded))
                                .padding()
                            Spacer()
                            HStack {
                                Spacer()
                                nextCardButton
                            }
                        }
                    )
            }
        )
        .frame(width: 250.0, height: 250.0)
        .animation(.easeOut(duration: taskViewModel.offsetAnimationDuration), value: taskViewModel.offset)
        .offset(y: taskViewModel.offset)
        .opacity(taskViewModel.opacity)

    }
    
    var rememberButton: some View {
        Button {
            withAnimation {
                taskViewModel.rememberWordAction()
            }
        } label: {
            Image(systemName: "checkmark")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 20.0, height: 20.0)
                .padding()
                .background(
                    Circle()
                        .foregroundColor(Color.gray.opacity(0.2))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                )
        }
        .padding()
    }
    
    var forgotButton: some View {
        Button {
            withAnimation {
                taskViewModel.forgotWordAction()
            }
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 20.0, height: 20.0)
                .padding()
                .background(
                    Circle()
                        .foregroundColor(Color.gray.opacity(0.2))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                )
        }
        .padding()
    }
    
    var nextCardButton: some View {
        Button {
            withAnimation {
                taskViewModel.nextWordAction()
            }
        } label: {
            Image(systemName: "checkmark")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 20.0, height: 20.0)
                .padding()
                .background(
                    Circle()
                        .foregroundColor(Color.gray.opacity(0.2))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                )
        }
        .padding()
    }
}
