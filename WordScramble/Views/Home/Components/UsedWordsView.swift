//
//  UsedWordsView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct UsedWordsView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    let parentWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Used Words")
                    .font(.headline)
                
                Spacer()
            }
            
            ForEach(viewModel.usedWords, id: \.self) { word in
                HStack {
                    Image(systemName: "\(word.count).circle")
                        .foregroundColor(.blue)
                    
                    Text(word)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    Spacer()
                    
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            Task {
                                await viewModel.fetchDefinition(for: word)
                            }
                        }
                }
                
                Spacer().frame(height: parentWidth * 0.02)
            }
        }
        .frame(width: parentWidth * 0.9)
    }
}
