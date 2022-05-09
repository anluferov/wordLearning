//
//  WordsDashboard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 4/11/22.
//

import SwiftUI

struct WordsDashboard: View {
    @ObservedObject private(set) var viewModel: WordsDashboardViewModel
    @EnvironmentObject private var newCardViewModel: NewWordCardViewModel
    
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            Text("Word Cards")
                .font(.system(size: 25, weight: .black, design: .rounded))
                .padding()
            
            // list with created cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5.0) {
                    ForEach(viewModel.dataSource, id: \.self) { topic in
                        Rectangle()
                            .cornerRadius(20.0)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                            .matchedGeometryEffect(id: newCardViewModel.state == .saving ? topic.rawValue : topic.rawValue + "disabled", in: namespace)
                            .frame(width: 200.0, height: 200.0)
                            .padding()
                            .overlay(
                                Text(topic.rawValue)
                                    .font(.system(size: 20, weight: .thin, design: .rounded))
                            )
                    }
                }
            }
            
            // block with motivation phrase
            Rectangle()
                .cornerRadius(20.0)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                .frame(height: 200.0)
                .padding()
                .overlay(
                    Text("Motivation phrase about learning words")
                        .font(.system(size: 20, weight: .thin, design: .rounded))
                )
            
            Spacer()
        }
        .onAppear(perform: {
            viewModel.loadAvaliableTopics()
        })
    }
}

struct WordsDashboard_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        WordsDashboard(viewModel: WordsDashboardViewModel.init(), namespace: namespace)
    }
}