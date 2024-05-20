//
//  WordChallengeView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct WordChallengeView: View {
    
    @Binding var rootWord: String
    @Binding var score: Int
    @ObservedObject var viewModel: HomeScreenViewModel
    let onTap: () -> Void
    let parentWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Image(systemName: "laurel.leading")
                
                Text("Your Challenge")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Image(systemName: "laurel.trailing")
            }
            
            Spacer().frame(height: parentWidth * 0.045)
            
            HStack {
                Text(rootWord)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Image(systemName: "info.circle")
                    .onTapGesture { onTap() }
            }
            
            Spacer().frame(height: parentWidth * 0.02)
            
            Text("Score: \(score)")
                .font(.title2)
                .foregroundColor(.secondary)
            
            TimerView(viewModel: viewModel)
                .frame(width: parentWidth * 0.9)
        }
    }
}
