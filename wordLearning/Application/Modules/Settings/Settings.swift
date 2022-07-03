//
//  Settings.swift
//  wordLearning
//
//  Created by Andrey Luferau on 7/2/22.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.system(size: 25, weight: .black, design: .rounded))
                .padding()
            Spacer()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
