//
//  ContentView.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct Preview: Identifiable {
    let id = UUID()
    let name: String
}

struct ContentView: View {
    @Namespace var namespace
    
    @State var dragCardsProgress: Double = 0.0
    
    @State private var backOpacity: Double = 0.0
    @State private var isCardSavingInProgress: Bool = false

    var body: some View {

        ZStack {
            if isCardSavingInProgress {
                VStack() {
                    HStack {
                        WordCardFront()
                            .matchedGeometryEffect(id: "wordCard", in: namespace)
                            .frame(width: 150.0, height: 150.0)
                            .padding(20.0)
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                VStack() {
                    HStack {
                        WordCardFront()
                            .frame(width: 150.0, height: 150.0)
                            .padding(20.0)
                        Spacer()
                    }
                    Spacer()
                }
            }

            Color(.black)
                .ignoresSafeArea()
                .opacity(isCardSavingInProgress ? 0.0 : dragCardsProgress)

            if !isCardSavingInProgress {
                CreationWordCardView(namespace: namespace, dragToCenterProgress: $dragCardsProgress)
            }


            Image(systemName: "plus")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
                .offset(x: 120, y: -350)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isCardSavingInProgress.toggle()
                        
                        Task {
                            await delayToggle()
                        }
                    }
                }

        }
    }
    
    private func delayToggle() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        dragCardsProgress = 0.0
        isCardSavingInProgress.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
