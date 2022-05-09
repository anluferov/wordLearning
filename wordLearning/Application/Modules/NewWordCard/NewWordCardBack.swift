//
//  WordCardBack.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct NewWordCardBack: View {
    @EnvironmentObject var viewModel: NewWordCardViewModel
    
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        Rectangle()
            .foregroundColor(viewModel.currentColor)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
            .overlay(topConfiguration, alignment: .topLeading)
            .overlay(nativeWordTextField, alignment: .center)
            .overlay(backButton, alignment: .bottomLeading)
            .overlay(saveButton, alignment: .bottomTrailing)
    }
    
    var nativeWordTextField: some View {
        TextField(viewModel.nativeTextPlaceholder, text: $viewModel.nativeText)
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .focused($textFieldIsFocused)
            .minimumScaleFactor(0.5)
            .padding()
    }
    
    var topConfiguration: some View {
        HStack {
            languageMenu
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10.0)
        .padding()
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
    
    var backButton: some View {
        Button {
            textFieldIsFocused = false
            viewModel.flipBackButtonAction()
        } label: {
            Image(systemName: "arrow.backward")
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
    
    var saveButton: some View {
        Button {
            textFieldIsFocused = false
            withAnimation {
                viewModel.saveButtonAction()
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

struct WordCardBack_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NewWordCardBack()
                .frame(width: 300.0, height: 300.0)
                .environmentObject(NewWordCardViewModel.init())
        }
    }
}
