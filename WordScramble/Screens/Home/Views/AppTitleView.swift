//
//  AppTitle.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct AppTitleView: View {
    
    let parentWidth: CGFloat
    
    var body: some View {
        HStack {
            Text("WordScramble")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
        }
        .frame(width: parentWidth * 0.9)
    }
}
