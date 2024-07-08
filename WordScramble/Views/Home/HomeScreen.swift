//
//  HomeScreen.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct HomeScreen: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    @EnvironmentObject var router: Router
    
    @FocusState var isTextFieldFocused: Bool
    @State var randomWord: String?
    let wordDatabase = WordDatabase()
    
    @State private var isDatabasePreloaded = false
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    HStack {
                        Text("Scramble")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: { router.navigate(to: .settings) }) {
                            Image(systemName: "gearshape")
                                .font(.title2)
                        }
                    }
                    
                    VStack {
                        VStack {
                            Spacer().frame(height: SpacerConstants.large)
                            
                            HStack {
                                Image(systemName: "laurel.leading")
                                
                                Text("Your Challenge")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Image(systemName: "laurel.trailing")
                            }
                            
                            Spacer().frame(height: SpacerConstants.large)
                            
                            HStack {
                                Text(viewModel.rootWord)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                Image(systemName: "info.circle")
                                    .onTapGesture {
                                        Task.detached {
                                            await viewModel.fetchDefinition(for: viewModel.rootWord)
                                        }
                                    }
                            }
                            
                            Spacer().frame(height: SpacerConstants.medium)
                            
                            Text("Score: \(viewModel.score)")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Spacer().frame(height: SpacerConstants.large)
                            
                            HStack {
                                Text("Time remaining: ")
                                
                                Text(viewModel.formattedTimeRemaining)
                                    .font(.body)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 15)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(10)
                            }
                            
                            Spacer().frame(height: SpacerConstants.large)
                        }
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("CardBackground"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 2)
                    .padding(.vertical)
                    .padding(.horizontal, 2) // prevents shadow from being clipped horizontally
                    
                    if viewModel.definitionIsLoading {
                        VStack {
                            HStack {
                                ProgressView().padding(.trailing, 5)
                                Text("Loading definition...")
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    if viewModel.showingDefinition {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Definition:")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("(\(viewModel.wordToBeDefined))")
                                    .font(.headline)
                                    .bold()
                                    .italic()
                            }
                            
                            HStack {
                                Text(viewModel.wordDefinition)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .cornerRadius(10)
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                Color(UIColor.systemGray6)
                                    .cornerRadius(10)
                            )
                            
                            Spacer().frame(height: SpacerConstants.large)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    HStack {
                        Button(action: {
                            viewModel.gameStarted = true
                            setFocus(true)
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
                            setFocus(true)
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
                    
                    HStack {
                        TextField("Enter your word", text: $viewModel.newWord)
                            .foregroundColor(.primary)
                            .opacity(0.8)
                            .padding(10)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .focused($isTextFieldFocused, equals: true)
                            .disabled(!viewModel.gameStarted || viewModel.gameEnded)
                            .onSubmit {
                                viewModel.addNewWord()
                                setFocus(false)
                            }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .strokeBorder(.secondary, style: StrokeStyle(lineWidth: 1.0))
                    )
                    .padding(.vertical)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Quit") {
                                viewModel.quitGame()
                                setFocus(false)
                            }
                        }
                    }
                    
                    if viewModel.showingError {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Nope:")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text(viewModel.errorMessage)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .cornerRadius(10)
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                Color(UIColor.systemRed).opacity(0.1)
                                    .cornerRadius(10)
                            )
                        }
                        .frame(maxWidth: .infinity)
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
                                        Task {
                                            await viewModel.fetchDefinition(for: word)
                                        }
                                    }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding()
                
                if viewModel.gameEnded {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "xmark")
                                .padding(.trailing)
                                .onTapGesture {
                                    viewModel.gameEnded = false
                                    viewModel.gameStarted = false
                                    viewModel.shouldFocus = false
                                }
                        }
                        
                        VStack {
                            Text("Game Over")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                            Text("Your Score: \(viewModel.score)")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 2)
                    .frame(width: 250, height: 225)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
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
        wordDatabase.loadWordsIfNeeded()
    }
}

#Preview {
    HomeScreen()
        .environmentObject(Router())
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
