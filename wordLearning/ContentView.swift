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

    var body: some View {
        ZStack {
            WordsDashboard(viewModel: WordsDashboardViewModel.init(), namespace: newCardNamespace)
            NewWordCard(namespace: newCardNamespace)
        }
        .environmentObject(NewWordCardViewModel.init())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
