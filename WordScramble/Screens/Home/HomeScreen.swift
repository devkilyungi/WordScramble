//
//  HomeScreen.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var viewModel = HomeScreenViewModel()
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        
        GeometryReader { geo in
                ZStack {
                    VStack {
                        ScrollView {
                            AppTitleView()
                                .frame(width: geo.size.width * 0.9)
                            
                            WordChallengeView(
                                rootWord: $viewModel.rootWord,
                                score: $viewModel.score,
                                viewModel: viewModel,
                                onTap: {
                                    viewModel.fetchDefinition(for: viewModel.rootWord)
                                },
                                parentWidth: geo.size.width
                            )
                            .frame(width: geo.size.width * 0.9, height: (UIApplication.shared.connectedScenes.first as! UIWindowScene).screen.nativeBounds.size.height * 0.09)
                            .cardBackground()
                            
                            if viewModel.definitionIsLoading {
                                VStack {
                                    DefinitionLoaderView()
                                        .frame(width: geo.size.width * 0.9)
                                    
                                    Spacer().frame(height: geo.size.width * 0.05)
                                }
                            }
                            
                            if viewModel.showingDefinition {
                                WordDefinitionView(
                                    wordToBeDefined: $viewModel.wordToBeDefined,
                                    wordDefinition: $viewModel.wordDefinition,
                                    parentWidth: geo.size.width
                                )
                                .frame(width: geo.size.width * 0.9)
                            }
                            
                            HStack {
                                Button(action: {
                                    viewModel.gameStarted = true
                                    viewModel.shouldFocus = true
                                    viewModel.startGame()
                                }) {
                                    Label("New Game", systemImage: "arrowtriangle.right.circle")
                                        .padding(.vertical, 5)
                                }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.roundedRectangle(radius: 15))
                                .shadow(radius: 2)
                                .disabled(viewModel.gameEnded)
                                
                                Spacer()
                                
                                Button(action:{
                                    viewModel.gameStarted = true
                                    viewModel.shouldFocus = true
                                    viewModel.restartGame()
                                }) {
                                    Label("Restart Game", systemImage: "arrow.circlepath")
                                        .padding(.vertical, 5)
                                }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.roundedRectangle(radius: 15))
                                .shadow(radius: 2)
                                .disabled(!viewModel.gameStarted || viewModel.gameEnded)
                            }
                            .frame(width: geo.size.width * 0.9)
                            
                            Spacer().frame(height: geo.size.width * 0.05)
                            
                            HStack {
                                TextField("Enter your word", text: $viewModel.newWord)
                                    .foregroundColor(.primary)
                                    .opacity(0.8)
                                    .padding(10)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .focused($isTextFieldFocused, equals: true)
                                    .disabled(!viewModel.gameStarted || viewModel.gameEnded)
                            }
                            .frame(width: geo.size.width * 0.9)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .strokeBorder(.secondary, style: StrokeStyle(lineWidth: 1.0))
                            )
                            
                            Spacer().frame(height: geo.size.width * 0.05)
                            
                            if viewModel.showingError {
                                ErrorView(
                                    errorMessage: $viewModel.errorMessage,
                                    parentWidth: geo.size.width
                                )
                                .frame(width: geo.size.width * 0.9)
                            }
                            
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
                                                viewModel.fetchDefinition(for: word)
                                            }
                                    }
                                    
                                    Spacer().frame(height: geo.size.width * 0.02)
                                }
                            }
                            .frame(width: geo.size.width * 0.9)
                            
                            Spacer()
                        }
                    }
                    .frame(height: geo.size.height)
                    
                    if viewModel.gameEnded {
                        GameEndedView(
                            gameEnded: $viewModel.gameEnded,
                            gameStarted: $viewModel.gameStarted,
                            shouldFocus: $viewModel.shouldFocus,
                            score: $viewModel.score,
                            parentWidth: geo.size.width
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .frame(
                            width: geo.size.width * 0.65,
                            height: geo.size.height * 0.2,
                            alignment: .center
                        )
                        .cardBackground()
                    }
                }
        }
        .onSubmit {
            viewModel.addNewWord()
            viewModel.shouldFocus = false
        }
        .onChange(of: viewModel.timeRemaining, {
            if viewModel.timeRemaining == 0 {
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
