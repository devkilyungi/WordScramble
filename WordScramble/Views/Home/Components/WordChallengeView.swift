//
//  WordChallengeView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct WordChallengeView: View {
    
    @ObservedObject var viewModel: MainViewModel
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
                Text(viewModel.rootWord)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Image(systemName: "info.circle")
                    .onTapGesture {
                        Task {
                            await viewModel.fetchDefinition(for: viewModel.rootWord)
                        }
                    }
            }
            
            Spacer().frame(height: parentWidth * 0.02)
            
            Text("Score: \(viewModel.score)")
                .font(.title2)
                .foregroundColor(.secondary)
            
            TimerView(viewModel: viewModel)
                .frame(width: parentWidth * 0.9)
        }
        .frame(width: parentWidth * 0.9, height: (UIApplication.shared.connectedScenes.first as! UIWindowScene).screen.nativeBounds.size.height * 0.09)
        .cardBackground()
    }
}
