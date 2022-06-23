//
//  WordsDashboard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/11/22.
//

import SwiftUI

struct WordsDashboard: View {
    @ObservedObject private(set) var viewModel: WordsDashboardViewModel
    //TODO: remove cardCreationViewModel from dashboard module
    @EnvironmentObject private var cardCreationViewModel: NewWordCardViewModel
    @EnvironmentObject private var cardTaskViewModel: WordCardTaskContainerViewModel
    
    //TODO: create animated appearance of wordCardTask
    var cardTaskNamespace: Namespace.ID
    var cardCreationNamespace: Namespace.ID
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            navigation
            if viewModel.dataSource.isEmpty {
                topicsDashboardPlaceholder
            } else {
                topicsDashboard
            }
            motivationBlock
            Spacer()
        }
        .onAppear(perform: {
            viewModel.loadAvaliableTopics()
        })
    }
    
    var navigation: some View {
        Text("Word Cards")
            .font(.system(size: 25, weight: .black, design: .rounded))
            .padding()
    }
    
    var topicsDashboard: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5.0) {
                ForEach(viewModel.dataSource, id: \.self) { wordsStack in
                    Rectangle()
                        .foregroundColor(wordsStack.color)
                        .cornerRadius(20.0)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                        .matchedGeometryEffect(id: cardCreationViewModel.state == .saving ? wordsStack.description : wordsStack.description + "disabled",
                                               in: cardCreationNamespace)
                        .matchedGeometryEffect(id: wordsStack.description, in: cardTaskNamespace)
                        .frame(width: 200.0, height: 200.0)
                        .padding()
                        .overlay(
                            Text(wordsStack.description)
                                .font(.system(size: 20, weight: .thin, design: .rounded))
                        )
                        .onTapGesture {
                            withAnimation {
                                cardTaskViewModel.startTaskAction(wordsStack.topic)
                            }
                        }
                        .background(
                            Rectangle()
                                .cornerRadius(18.0)
                                .foregroundColor(wordsStack.hasSeveralCards ? wordsStack.color : .clear)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                                .frame(width: 180.0, height: 200.0)
                                .offset(x: 0.0, y: -10.0)
                        )
                }
            }
        }
    }
    
    var topicsDashboardPlaceholder: some View {
        Rectangle()
            .cornerRadius(20.0)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
            .frame(height: 200.0)
            .padding()
            .overlay(
                Text("Your cards collection be shown here after adding first word card.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .thin, design: .rounded))
            )
    }
    
    var motivationBlock: some View {
        Rectangle()
            .cornerRadius(20.0)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
            .frame(height: 200.0)
            .padding()
            .overlay(
                Text("Motivation phrase about learning words")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .thin, design: .rounded))
            )
    }
}

struct WordsDashboard_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        WordsDashboard(viewModel: WordsDashboardViewModel.init(), cardTaskNamespace: namespace, cardCreationNamespace: namespace)
    }
}
