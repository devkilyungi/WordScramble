//
//  CardBackground.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("CardBackground"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 2)
            .padding()
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}
