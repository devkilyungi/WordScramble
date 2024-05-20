//
//  HomeScreen.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct HomeScreen: View {
    
    @EnvironmentObject private var viewModel: HomeScreenViewModel
    
    @FocusState var isTextFieldFocused: Bool
    @State var randomWord: String?
    let wordDatabase = WordDatabase()
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                VStack {
                    ScrollView {
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
                        
                        Spacer()
                    }
                }
                .frame(height: geo.size.height)
                
                if viewModel.gameEnded {
                    GameEndedView(
                        viewModel: viewModel,
                        parentWidth: geo.size.width,
                        parentHeight: geo.size.height
                    )
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
    }
}

#Preview {
    HomeScreen()
}

extension HomeScreen {
    func setFocus(_ shouldFocus: Bool) {
        withAnimation {
            viewModel.shouldFocus = shouldFocus
            isTextFieldFocused = shouldFocus
        }
    }
}