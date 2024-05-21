//
//  HomeScreen.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct HomeScreen: View {
    
    @EnvironmentObject private var viewModel: MainViewModel
    
    @FocusState var isTextFieldFocused: Bool
    @State var randomWord: String?
    let wordDatabase = WordDatabase()
    
    @State private var isDatabasePreloaded = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView {
                    VStack {
                        AppTitleView(
                            viewModel: viewModel,
                            parentWidth: geo.size.width
                        )
                        
                        WordChallengeView(
                            viewModel: viewModel,
                            parentWidth: geo.size.width
                        )
                        
                        if viewModel.definitionIsLoading {
                            VStack {
                                DefinitionLoaderView(parentWidth: geo.size.width)
                                Spacer().frame(height: geo.size.width * 0.05)
                            }
                        }
                        
                        if viewModel.showingDefinition {
                            WordDefinitionView(
                                wordToBeDefined: $viewModel.wordToBeDefined,
                                wordDefinition: $viewModel.wordDefinition,
                                parentWidth: geo.size.width
                            )
                        }
                        
                        ButtonSelectionView(
                            viewModel: viewModel,
                            parentWidth: geo.size.width,
                            focusAction: {
                                setFocus(true)
                            }
                        )
                        
                        Spacer().frame(height: geo.size.width * 0.05)
                        
                        TextFieldSectionView(
                            viewModel: viewModel,
                            parentWidth: geo.size.width,
                            isTextFieldFocused: _isTextFieldFocused,
                            onSubmit: {
                                viewModel.addNewWord()
                                setFocus(false)
                            },
                            focusAction: {
                                setFocus(false)
                            }
                        )
                        
                        Spacer().frame(height: geo.size.width * 0.05)
                        
                        if viewModel.showingError {
                            ErrorView(
                                errorMessage: $viewModel.errorMessage,
                                parentWidth: geo.size.width
                            )
                        }
                        
                        UsedWordsView(viewModel: viewModel, parentWidth: geo.size.width)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
                if viewModel.gameEnded {
                    GameEndedView(
                        viewModel: viewModel,
                        parentWidth: geo.size.width,
                        parentHeight: geo.size.height
                    )
                }
            }
        }
        .onAppear {
            // Preload the database
            if !isDatabasePreloaded {
                DispatchQueue.global().async {
                    preloadDatabase()
                    isDatabasePreloaded = true
                }
            }
        }
        .onChange(of: viewModel.selectedTimeRemaining, {
            if viewModel.selectedTimeRemaining == 0 {
                withAnimation {
                    viewModel.gameEnded = true
                }
            }
        })
        .onChange(of: viewModel.shouldFocus, {
            if viewModel.shouldFocus {
                isTextFieldFocused = true
            } else {
                isTextFieldFocused = false
            }
        })
        .onChange(of: viewModel.gameEnded, {
            if viewModel.gameEnded {
                viewModel.saveGameHistory()
            }
        })
    }
    
    func preloadDatabase() {
            let wordDatabase = WordDatabase()
            // Fetch a random word to preload the database
            _ = wordDatabase.getRandomWord(from: "\(viewModel.wordSize.wordForm)_letter_words")
        }
}

#Preview {
    HomeScreen()
        .environmentObject(MainViewModel())
}

extension HomeScreen {
    func setFocus(_ shouldFocus: Bool) {
        withAnimation {
            viewModel.shouldFocus = shouldFocus
            isTextFieldFocused = shouldFocus
        }
    }
}
