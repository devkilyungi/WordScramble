//
//  HomeScreenViewModel.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI
import Combine

class HomeScreenViewModel: ObservableObject {
    
    @Published var usedWords = [String]()
    @Published var rootWord = "Scramble"
    @Published var newWord = ""
    @Published var score = 0
    
    @Published var gameStarted = false
    @Published var gameEnded = false
    
    @Published var errorMessage = ""
    @Published var showingError = false
    
    @Published var definitionIsLoading = false
    @Published var showingDefinition = false
    @Published var wordDefinition = ""
    @Published var wordToBeDefined = ""
    
    @Published var shouldFocus = false
    
    @Published var timeRemaining: Int = GameDuration.oneAndHalfMinutes.rawValue
    private var timer: AnyCancellable?
    
    let dictionaryAPI = DictionaryAPI()
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                withAnimation {
                    usedWords = []
                }
                newWord = ""
                score = 0
                startTimer()
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func restartGame() {
        withAnimation {
            usedWords.removeAll()
        }
        startGame()
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 1 else {
            wordError(message: "You can't have a one letter or blank word!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            withAnimation {
                showingError = false
                usedWords.insert(answer, at: 0)
            }
        }
        score += answer.count
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(message: String) {
        withAnimation {
            errorMessage = message
            showingError = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            withAnimation {
                self.showingError = false
            }
        })
    }
    
    func fetchDefinition(for word: String) {
        withAnimation {
            definitionIsLoading = true
            showingDefinition = false
        }
        
        dictionaryAPI.fetchDefinition(for: word) { result in
            DispatchQueue.main.async {
                withAnimation {
                    self.definitionIsLoading = false
                }
                
                switch result {
                case .success(let definition):
                    self.wordToBeDefined = word
                    self.wordDefinition = definition
                    withAnimation {
                        self.showingDefinition = true
                    }
                case .failure(let error):
                    var errorMessage: String
                    switch error {
                    case let nsError as NSError:
                        if nsError.domain == "No definition found" {
                            errorMessage = "No definition found for '\(word)'"
                        } else {
                            errorMessage = nsError.localizedDescription
                        }
                    default:
                        errorMessage = error.localizedDescription
                    }
                    self.wordError(message: errorMessage)
                }
            }
        }
    }
    
    func startTimer() {
        timeRemaining = GameDuration.oneAndHalfMinutes.rawValue
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.cancel()
                }
            }
    }
    
    var formattedTimeRemaining: String {
        if timeRemaining >= 60 {
            let minutes = timeRemaining / 60
            let seconds = timeRemaining % 60
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return String(format: "00:%02d", timeRemaining)
        }
    }
    
    deinit {
        timer?.cancel()
    }
}
