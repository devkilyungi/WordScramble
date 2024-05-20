//
//  ButtonSelectionView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct ButtonSelectionView: View {
    
    @ObservedObject var viewModel = HomeScreenViewModel()
    let parentWidth: CGFloat
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.gameStarted = true
                viewModel.shouldFocus = true
                viewModel.startGame()
            }) {
                Label("New Game", systemImage: "arrowtriangle.right.circle")
                    .padding(.vertical, 5)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 15))
            .shadow(radius: 2)
            .disabled(viewModel.gameEnded)
            
            Spacer()
            
            Button(action:{
                viewModel.gameStarted = true
                viewModel.shouldFocus = true
                viewModel.restartGame()
            }) {
                Label("Restart Game", systemImage: "arrow.circlepath")
                    .padding(.vertical, 5)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 15))
            .shadow(radius: 2)
            .disabled(!viewModel.gameStarted || viewModel.gameEnded)
        }
        .frame(width: parentWidth * 0.9)
    }
}
