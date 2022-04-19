//
//  WordCardFront.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct NewWordCardFront: View {
    @ObservedObject private(set) var viewModel: NewWordCardFrontViewModel
    
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        ZStack {
            ColorfulRectangleView(color: viewModel.currentColor)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                .overlay(colorButton, alignment: .topLeading)
                .overlay(topHint, alignment: .top)
                .overlay(toLearnWordTextField, alignment: .center)

        }
    }
    
    // Views
    
    var toLearnWordTextField: some View {
        TextField("Enter word to learn", text: $viewModel.toLearnText)
            .textFieldStyle(.roundedBorder)
            .font(.title)
            .focused($textFieldIsFocused)
            .minimumScaleFactor(0.5)
            .padding()
    }
    
    var colorButton: some View {
        Circle()
            .foregroundColor(viewModel.nextColor)
            .frame(width: 30.0, height: 30.0)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
            .padding(20)
            .animation(.linear, value: viewModel.topActionsBlurRadius)
            .blur(radius: viewModel.topActionsBlurRadius)
            .onTapGesture {
                viewModel.selectNextColor()
            }
    }
    
    var topHint: some View {
        Text("Swipe up to create new card")
            .font(.footnote)
            .padding()
            .animation(.linear, value: viewModel.hintOpacity)
            .opacity(viewModel.hintOpacity)
    }
}

struct WordCardFront_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NewWordCardFront(viewModel: NewWordCardFrontViewModel.init())
                .frame(width: 300.0, height: 300.0)
        }
    }
}
