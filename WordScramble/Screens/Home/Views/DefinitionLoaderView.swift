//
//  DefinitionLoaderView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct DefinitionLoaderView: View {
    var body: some View {
        HStack {
            ProgressView().padding(.trailing, 5)
            Text("Loading definition...")
        }
    }
}
