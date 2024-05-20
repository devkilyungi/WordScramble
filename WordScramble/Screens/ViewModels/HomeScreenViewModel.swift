//
//  HomeScreenViewModel.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI
import Combine

@MainActor
class HomeScreenViewModel: ObservableObject {
    
    @Published var usedWords = [String]()
    @Published var rootWord = "Scramble"
    @Published var newWord = ""
    @Published var score = 0
    @Published var wordSize: WordLength = .eight
    
    @Published var gameStarted = false
    @Published var gameEnded = false
    
    @Published var errorMessage = ""
    @Published var showingError = false
    
    @Published var definitionIsLoading = false
    @Published var showingDefinition = false
    @Published var wordDefinition = ""
    @Published var wordToBeDefined = ""
    
    @Published var shouldFocus = false
    
    private var timer: AnyCancellable?
    @Published var selectedTimeRemaining: Int = GameDuration.oneAndHalfMinutes.rawValue
    @Published var gameDuration: GameDuration = .oneAndHalfMinutes
    
    let dictionaryAPI = DictionaryAPI()
    
    func isValidWord(_ word: String, language: String = "en") -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: language)
        return misspelledRange.location == NSNotFound
    }
    
    func startGame() {
        // Attempt to fetch a random word from the database
        let wordDatabase = WordDatabase()
        var randomWord: String?
        while randomWord == nil || !isValidWord(randomWord!) {
            randomWord = wordDatabase.getRandomWord(from: "\(wordSize.wordForm)_letter_words")
        }
        
        // Assign the fetched random word to the rootWord property
        guard let validRandomWord = randomWord else {
            fatalError("Could not fetch a valid random word from the database.")
        }
        rootWord = validRandomWord
        
        // Reset other game-related properties
        withAnimation {
            usedWords = []
            newWord = ""
            score = 0
        }
        
        // Start the game timer
        startTimer()
    }
    
    func quitGame() {
        gameStarted = false
        gameEnded = true
        shouldFocus = false
        stopTimer()
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
    
    func fetchDefinition(for word: String) async {
        withAnimation {
            definitionIsLoading = true
            showingDefinition = false
        }
        
        do {
            let definition = try await dictionaryAPI.fetchDefinition(for: word)
            wordToBeDefined = word
            wordDefinition = definition
            withAnimation {
                definitionIsLoading = false
                showingDefinition = true
            }
        } catch {
            let nsError = error as NSError
            let errorMessage: String
            if nsError.domain == "No definition found" {
                errorMessage = "No definition found for '\(word)'"
            } else {
                errorMessage = nsError.localizedDescription
            }
            withAnimation {
                definitionIsLoading = false
            }
            wordError(message: errorMessage)
        }
    }
    
    func startTimer() {
        selectedTimeRemaining = gameDuration.rawValue
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.selectedTimeRemaining > 0 {
                    self.selectedTimeRemaining -= 1
                } else {
                    self.timer?.cancel()
                }
            }
    }
    
    func stopTimer() {
        timer?.cancel()
    }
    
    var formattedTimeRemaining: String {
        if selectedTimeRemaining >= 60 {
            let minutes = selectedTimeRemaining / 60
            let seconds = selectedTimeRemaining % 60
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return String(format: "00:%02d", selectedTimeRemaining)
        }
    }
    
    deinit {
        timer?.cancel()
    }
}
