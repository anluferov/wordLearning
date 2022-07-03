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
        TabBar()
            .environmentObject(TabBarViewModel())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
