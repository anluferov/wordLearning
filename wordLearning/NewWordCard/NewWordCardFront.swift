//
//  WordCardFront.swift
//  wordLearning
//
//  Created by Andrey Luferau on 3/27/22.
//

import SwiftUI

struct NewWordCardFront: View {
    @ObservedObject private(set) var viewModel: NewWordCardFrontViewModel
    
    let colors: [Color] = [.white, .orange, .red, .gray, .green, .blue]
    
    @State private var activeColorIndex: Int = 0
    
    @State private var hintOpacity: Double = 1.0
    @State private var topActionsBlurRadius: Double = 0.0
    
    var body: some View {
        ZStack {
            ColorfulRectangleView(color: viewModel.currentColor)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                .overlay(colorButton, alignment: .topLeading)
                .overlay(topHint, alignment: .top)
                .overlay(contentDetails, alignment: .center)

        }
    }
    
    // Views
    
    var colorButton: some View {
        Circle()
            .foregroundColor(viewModel.nextColor)
            .frame(width: 30.0, height: 30.0)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
            .padding(20)
            .animation(.linear, value: viewModel.topActionsBlurRadius)
            .blur(radius: viewModel.topActionsBlurRadius)
            .onTapGesture {
                viewModel.selectNextColor()
            }
    }
    
    var topHint: some View {
        Text("Swipe up to create new card")
            .font(.footnote)
            .padding()
            .animation(.linear, value: viewModel.hintOpacity)
            .opacity(viewModel.hintOpacity)
    }
    
    var contentDetails: some View {
        Image(systemName: "house.fill")
            .resizable()
            .frame(width: 50.0, height: 50.0)
            .foregroundColor(.red)
            .padding()
            .background(.white)
            .cornerRadius(20)
    }
    
    // Logic
    
    var nextColorIndex: Int {
        (activeColorIndex + 1) % colors.count
    }
}

struct WordCardFront_Previews: PreviewProvider {
    static var previews: some View {
        NewWordCardFront(viewModel: NewWordCardFrontViewModel.init())
            .frame(width: 300.0, height: 300.0)
    }
}
