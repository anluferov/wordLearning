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
    @Namespace var cardCreationNamespace
    @Namespace var taskСardNamespace

    var body: some View {
        ZStack {
            //-------------------------------------------------------
            // Main View: Dashboard with list of cards (zIndex = 1)
            //-------------------------------------------------------
            WordsDashboard(viewModel: WordsDashboardViewModel.init(), cardTaskNamespace: taskСardNamespace, cardCreationNamespace: cardCreationNamespace)
                .zIndex(1)
            
            //-------------------------------------------------------
            // Modal View: swappable new card (creation new card flow) (zIndex = 2)
            //-------------------------------------------------------
            NewWordCard(namespace: cardCreationNamespace)
                .zIndex(2)
            
            //-------------------------------------------------------
            // Modal View: container for task with word cards (zIndex = 3)
            //-------------------------------------------------------
            WordCardTaskContainer(namespace: taskСardNamespace)
                .zIndex(3)
        }
        .environmentObject(NewWordCardViewModel())
        .environmentObject(WordCardTaskContainerViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
