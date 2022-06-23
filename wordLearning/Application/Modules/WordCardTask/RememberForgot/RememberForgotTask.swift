//
//  RememberForgotTask.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/12/22.
//

import SwiftUI

struct RememberForgotTask: View {
    @ObservedObject var viewModel: RememberForgotTaskViewModel
    
    init?(viewModel: WordTaskViewModel?) {
        guard let rememberForgotTaskViewModel = viewModel as? RememberForgotTaskViewModel else {
            return nil
        }
        
        self.viewModel = rememberForgotTaskViewModel
    }
    
    var body: some View {
        RotatableView(
            isFlipped: $viewModel.isWordCardFlipped,
            animated: $viewModel.isFlippingAnimated,
            frontContent: {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                    .overlay(
                        VStack {
                            Spacer()
                            Text(viewModel.currentWordCard?.nativeWord.text ?? "")
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
                            Text(viewModel.currentWordCard?.toLearnWord.text ?? "")
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
        .animation(.easeOut(duration: viewModel.offsetAnimationDuration), value: viewModel.offset)
        .offset(y: viewModel.offset)
        .opacity(viewModel.opacity)

    }
    
    var rememberButton: some View {
        Button {
            withAnimation {
                viewModel.rememberWordAction()
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
                viewModel.forgotWordAction()
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
                viewModel.nextWordAction()
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
