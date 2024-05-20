//
//  GameEndedView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct GameEndedView: View {
    
    @Binding var gameEnded: Bool
    @Binding var gameStarted: Bool
    @Binding var shouldFocus: Bool
    @Binding var score: Int
    let parentWidth: CGFloat
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Image(systemName: "xmark")
                    .padding(.trailing)
                    .onTapGesture {
                        gameEnded = false
                        gameStarted = false
                        shouldFocus = false
                    }
            }
            
            Text("Game Over")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            Spacer().frame(height: parentWidth * 0.02)
            
            Text("Your Score: \(score)")
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}
