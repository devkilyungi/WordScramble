//
//  ErrorView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct ErrorView: View {
    
    @Binding var errorMessage: String
    let parentWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Nope:")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding()
                    .cornerRadius(10)
            }
            .frame(width: parentWidth * 0.9)
            .background(
                Color(UIColor.systemRed).opacity(0.1)
                    .cornerRadius(10)
            )
            
            Spacer().frame(height: parentWidth * 0.05)
        }
    }
}
