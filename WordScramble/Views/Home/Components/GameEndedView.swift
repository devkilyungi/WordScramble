//
//  GameEndedView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct GameEndedView: View {
    
    @ObservedObject var viewModel: MainViewModel
    let parentWidth: CGFloat
    let parentHeight: CGFloat
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Image(systemName: "xmark")
                    .padding(.trailing)
                    .onTapGesture {
                        viewModel.gameEnded = false
                        viewModel.gameStarted = false
                        viewModel.shouldFocus = false
                    }
            }
            
            Text("Game Over")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            Spacer().frame(height: parentWidth * 0.02)
            
            Text("Your Score: \(viewModel.score)")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .frame(
            width: parentWidth * 0.65,
            height: parentHeight * 0.2,
            alignment: .center
        )
        .cardBackground()
    }
}
