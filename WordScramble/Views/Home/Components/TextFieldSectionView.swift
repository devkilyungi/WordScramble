//
//  TextFieldSectionView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct TextFieldSectionView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    let parentWidth: CGFloat
    @FocusState var isTextFieldFocused: Bool
    let onSubmit: () -> Void
    let focusAction: () -> Void
    
    var body: some View {
        HStack {
            TextField("Enter your word", text: $viewModel.newWord)
                .foregroundColor(.primary)
                .opacity(0.8)
                .padding(10)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .focused($isTextFieldFocused, equals: true)
                .disabled(!viewModel.gameStarted || viewModel.gameEnded)
                .onSubmit { onSubmit() }
        }
        .frame(width: parentWidth * 0.9)
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .strokeBorder(.secondary, style: StrokeStyle(lineWidth: 1.0))
        )
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Quit") {
                    viewModel.quitGame()
                    focusAction()
                }
            }
        }
    }
}
