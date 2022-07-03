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
            WordsDashboard(viewModel: WordsDashboardViewModel.init(), cardTaskNamespace: taskСardNamespace, cardCreationNamespace: cardCreationNamespace)
            NewWordCard(namespace: cardCreationNamespace)
            WordCardTaskContainer(namespace: taskСardNamespace)
        }
    }
}

struct MainCard_Previews: PreviewProvider {
    static var previews: some View {
        MainCard()
    }
}
