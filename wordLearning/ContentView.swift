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
    @Namespace var newCardNamespace

    @State private var dragNewCardsProgress: Double = 0.0

    @State private var backOpacity: Double = 0.0
    @State private var isCardSavingInProgress: Bool = false

    var body: some View {
        ZStack {
//            if isCardSavingInProgress {
//                VStack() {
//                    HStack {
//                        Rectangle()
//                            .cornerRadius(20.0)
//                            .foregroundColor(.white)
//                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
//                            .matchedGeometryEffect(id: "wordCard", in: newCardNamespace)
//                            .frame(width: 150.0, height: 150.0)
//                            .padding(20.0)
//                        Spacer()
//                    }
//                    Spacer()
//                }
//            } else {
//                VStack() {
//                    HStack {
//                        Rectangle()
//                            .cornerRadius(20.0)
//                            .foregroundColor(.white)
//                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
//                            .frame(width: 150.0, height: 150.0)
//                            .padding(20.0)
//                        Spacer()
//                    }
//                    Spacer()
//                }
//            }
//
//            Color(.black)
//                .ignoresSafeArea()
//                .opacity(isCardSavingInProgress ? 0.0 : dragNewCardsProgress)
            
            WordsDashboard(viewModel: WordsDashboardViewModel.init(), namespace: newCardNamespace)

            if !isCardSavingInProgress {
                NewWordCard(namespace: newCardNamespace)
                    .environmentObject(NewWordCardViewModel.init())
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

        dragNewCardsProgress = 0.0
        isCardSavingInProgress.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
