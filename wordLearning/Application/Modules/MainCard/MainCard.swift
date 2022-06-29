//
//  MainCard.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/26/22.
//

import SwiftUI

struct MainCard: View {
    @Namespace var cardCreationNamespace
    @Namespace var taskСardNamespace
    
    var body: some View {
        ZStack {
            //-------------------------------------------------------
            // Main View: Dashboard with list of cards (zIndex = 1)
            //-------------------------------------------------------
            WordsDashboard(viewModel: WordsDashboardViewModel.init(), cardTaskNamespace: taskСardNamespace, cardCreationNamespace: cardCreationNamespace)

            //-------------------------------------------------------
            // Modal View: swappable new card (creation new card flow) (zIndex = 2)
            //-------------------------------------------------------
            NewWordCard(namespace: cardCreationNamespace)
            
            //-------------------------------------------------------
            // Modal View: container for task with word cards (zIndex = 3)
            //-------------------------------------------------------
            WordCardTaskContainer(namespace: taskСardNamespace)
        }
        .environmentObject(NewWordCardViewModel())
        .environmentObject(WordCardTaskContainerViewModel())
    }
}

struct MainCard_Previews: PreviewProvider {
    static var previews: some View {
        MainCard()
    }
}
