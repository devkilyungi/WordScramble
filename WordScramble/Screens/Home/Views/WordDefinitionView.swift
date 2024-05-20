//
//  WordDefinitionView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct WordDefinitionView: View {
    
    @Binding var wordToBeDefined: String
    @Binding var wordDefinition: String
    let parentWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Definition:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("(\(wordToBeDefined))")
                    .font(.headline)
                    .bold()
                    .italic()
            }
            .frame(width: parentWidth * 0.9)
            
            HStack {
                Text(wordDefinition)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding()
                    .cornerRadius(10)
            }
            .frame(width: parentWidth * 0.9)
            .background(
                Color(UIColor.systemGray6)
                    .cornerRadius(10)
            )
            
            Spacer().frame(height: parentWidth * 0.05)
        }
    }
}
