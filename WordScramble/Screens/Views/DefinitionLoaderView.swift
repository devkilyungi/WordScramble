//
//  DefinitionLoaderView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct DefinitionLoaderView: View {
    
    let parentWidth: CGFloat
    
    var body: some View {
        HStack {
            ProgressView().padding(.trailing, 5)
            Text("Loading definition...")
        }
        .frame(width: parentWidth * 0.9)
    }
}
