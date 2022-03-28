//
//  WordCardFront.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct WordCardFront : View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0)
                .fill(.white)
                .shadow(color: .red, radius: 2, x: 0, y: 0)
            Image(systemName: "house.fill")
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(.red)
        }
    }
}

struct WordCardFront_Previews: PreviewProvider {
    static var previews: some View {
        WordCardFront()
            .frame(width: 300.0, height: 300.0)
    }
}
