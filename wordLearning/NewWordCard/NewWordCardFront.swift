//
//  WordCardFront.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct NewWordCardFront: View {
    @EnvironmentObject var viewModel: NewWordCardViewModel
    
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        ColorfulRectangleView(color: viewModel.currentColor)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
            .overlay(topConfiguration, alignment: .topLeading)
            .overlay(topHint, alignment: .top)
            .overlay(toLearnWordTextField, alignment: .center)
            .overlay(nextButton, alignment: .bottomTrailing)
    }
    
    var topConfiguration: some View {
        HStack {
            languageMenu
            topicMenu
            Spacer()
            colorButton
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10.0)
        .padding()
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        .animation(.linear, value: viewModel.topConfigurationBlurRadius)
        .blur(radius: viewModel.topConfigurationBlurRadius)
    }
    
    var toLearnWordTextField: some View {
        TextField(viewModel.toLearnTextPlaceholder, text: $viewModel.toLearnText)
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .focused($textFieldIsFocused)
            .minimumScaleFactor(0.5)
            .padding()
    }
    
    var nextButton: some View {
        Button {
            textFieldIsFocused = false
            viewModel.flipForwardButtonAction()
        } label: {
            Image(systemName: "arrow.forward")
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
    
    var colorButton: some View {
        Circle()
            .foregroundColor(viewModel.nextAvaliableColor)
            .frame(width: 30.0, height: 30.0)
            .onTapGesture {
                viewModel.updateColorToNextAvaliable()
            }
    }
    
    var languageMenu: some View {
        Menu(viewModel.toLearnLanguage) {
            ForEach(viewModel.languages, id: \.self) { language in
                Button(language) {
                    viewModel.updateToLearnLanguageAction(language)
                }
            }
        }
        .menuStyle(CustomConfigurationMenuStyle())
    }
    
    var topicMenu: some View {
        Menu(viewModel.topic?.rawValue ?? viewModel.topicPlaceholder) {
            ForEach(viewModel.topics, id: \.self) { topic in
                Button(topic.rawValue) {
                    viewModel.updateTopicAction(topic)
                }
            }
        }
        .menuStyle(CustomConfigurationMenuStyle())
    }
    
    var topHint: some View {
        Text("Swipe up to create new card")
            .font(.system(size: 12, weight: .thin, design: .rounded))
            .padding()
            .animation(.linear, value: viewModel.hintOpacity)
            .opacity(viewModel.hintOpacity)
    }
}

fileprivate struct CustomConfigurationMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .foregroundColor(.gray)
            .font(.system(size: 10, weight: .thin, design: .rounded))
            .padding(5.0)
            .background(.white)
            .cornerRadius(5.0)
    }
}

struct WordCardFront_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NewWordCardFront()
                .frame(width: 300.0, height: 300.0)
                .environmentObject(NewWordCardViewModel.init())
        }
    }
}
