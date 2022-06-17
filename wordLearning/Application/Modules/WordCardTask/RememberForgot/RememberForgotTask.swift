//
//  RememberForgotTask.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/12/22.
//

import SwiftUI

struct RememberForgotTask: View {
    @ObservedObject var viewModel: RememberForgotTaskViewModel
    
    var body: some View {
        RotatableView(
            isFlipped: $viewModel.isCurrentWordCardFlipped,
            frontContent: {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                    .overlay(
                        VStack {
                            Spacer()
                            Text("NATIVE WORD")
                                .font(.system(size: 25, weight: .black, design: .rounded))
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
                            Text("TRANSLATED WORD")
                                .font(.system(size: 25, weight: .black, design: .rounded))
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
    }
    
    var rememberButton: some View {
        Button {
            viewModel.rememberAction()
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
            viewModel.forgotAction()
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
            viewModel.nextCardAction()
        } label: {
            Image(systemName: "chevron.right")
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
