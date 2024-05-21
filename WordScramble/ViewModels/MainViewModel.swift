//
//  HomeScreenViewModel.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI
import Combine

@MainActor
class MainViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // Game state
    @Published var usedWords = [String]()
    @Published var rootWord = "Scramble"
    @Published var newWord = ""
    @Published var score = 0
    @Published var wordSize: WordLength = .eight
    
    // Game management
    @Published var gameStarted = false
    @Published var gameEnded = false
    @Published var selectedTimeRemaining: Int = GameDuration.oneAndHalfMinutes.rawValue
    @Published var gameDuration: GameDuration = .oneAndHalfMinutes
    
    // Error handling
    @Published var errorMessage = ""
    @Published var showingError = false
    
    // Dictionary API
    @Published var definitionIsLoading = false
    @Published var showingDefinition = false
    @Published var wordDefinition = ""
    @Published var wordToBeDefined = ""
    
    // Focus management
    @Published var shouldFocus = false
    
    // High score
    @Published var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    
    // MARK: - Private Properties
    
    private var timer: AnyCancellable?
    private let dictionaryAPI = DictionaryAPI()
    
    // MARK: - Computed Properties
    
    var formattedTimeRemaining: String {
        // Format the remaining time for display
        if selectedTimeRemaining >= 60 {
            let minutes = selectedTimeRemaining / 60
            let seconds = selectedTimeRemaining % 60
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return String(format: "00:%02d", selectedTimeRemaining)
        }
    }
    
    // MARK: - Initializers
    
    init() {
        // Load game settings from UserDefaults
        loadGameSettings()
    }
    
    // MARK: - Public Methods
    
    func startGame() {
        // Fetch a random word from the database
        fetchRandomWord()
        
        // Reset game-related properties
        resetGameProperties()
        
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
        resetGameProperties()
        startGame()
    }
    
    func addNewWord() {
        // Validate and process the new word
        guard let answer = processNewWord() else { return }
        
        // Update game state
        updateGameState(for: answer)
    }
    
    func fetchDefinition(for word: String) async {
        withAnimation {
            definitionIsLoading = true
            showingDefinition = false
        }
        
        // Fetch the definition for the given word
        do {
            let definition = try await dictionaryAPI.fetchDefinition(for: word)
            updateDefinitionState(word: word, definition: definition)
        } catch {
            handleDefinitionError(error: error, for: word)
        }
    }
    
    func isValidWord(_ word: String, language: String = "en") -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: language)
        return misspelledRange.location == NSNotFound
    }
    
    func saveGameHistory() {
        let isHighScore = score > highScore
        
        // Save high score if necessary
        if isHighScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "HighScore")
        }
        
        // Save game history
        var history = fetchGameHistory()
        
        // Mark all previous entries as not high scores if this is a new high score
        if isHighScore {
            for i in 0..<history.count {
                history[i].isHighScore = false
            }
        }
        
        // Append the new game history entry
        let gameHistory = GameHistory(
            rootWord: rootWord,
            score: score,
            duration: gameDuration.rawValue,
            date: Date(),
            isHighScore: isHighScore
        )
        
        history.append(gameHistory)
        
        // Save the updated history to UserDefaults
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: "GameHistory")
        }
    }
    
    func fetchGameHistory() -> [GameHistory] {
        if let savedHistory = UserDefaults.standard.data(forKey: "GameHistory"),
           let decodedHistory = try? JSONDecoder().decode([GameHistory].self, from: savedHistory) {
            return decodedHistory
        }
        return []
    }
    
    // MARK: - Private Methods
    
    private func loadGameSettings() {
        // Load game duration from UserDefaults
        if let storedGameDuration = UserDefaults.standard.value(forKey: "GameDuration") as? Int,
           let gameDuration = GameDuration(rawValue: storedGameDuration) {
            self.gameDuration = gameDuration
            self.selectedTimeRemaining = self.gameDuration.rawValue
        } else {
            self.gameDuration = .oneAndHalfMinutes
            self.selectedTimeRemaining = self.gameDuration.rawValue
        }
        
        // Load word size from UserDefaults
        if let storedWordSize = UserDefaults.standard.value(forKey: "WordSize") as? Int,
           let wordSize = WordLength(rawValue: storedWordSize) {
            self.wordSize = wordSize
        } else {
            self.wordSize = .eight
        }
    }
    
    private func fetchRandomWord() {
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
    }
    
    private func resetGameProperties() {
        // Reset game-related properties
        withAnimation {
            usedWords = []
            newWord = ""
            score = 0
            gameStarted = true
            gameEnded = false
        }
    }
    
    private func startTimer() {
        // Start the game timer
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
    
    private func stopTimer() {
        // Stop the game timer
        timer?.cancel()
    }
    
    private func processNewWord() -> String? {
        // Process the new word and perform validations
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 1 else {
            wordError(message: "You can't have a one letter or blank word!")
            return nil
        }
        
        guard isOriginal(word: answer) else {
            wordError(message: "Be more original")
            return nil
        }
        
        guard isPossible(word: answer) else {
            wordError(message: "You can't spell that word from '\(rootWord)'!")
            return nil
        }
        
        guard isReal(word: answer) else {
            wordError(message: "You can't just make them up, you know!")
            return nil
        }
        
        return answer
    }
    
    private func updateGameState(for word: String) {
        // Update game state after processing the new word
        withAnimation {
            withAnimation {
                showingError = false
                usedWords.insert(word, at: 0)
            }
        }
        score += word.count
        newWord = ""
    }
    
    private func isOriginal(word: String) -> Bool {
        // Check if the word is original (not already used)
        !usedWords.contains(word)
    }
    
    private func isPossible(word: String) -> Bool {
        // Check if the word is possible (can be formed from rootWord)
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
    
    private func isReal(word: String) -> Bool {
        // Check if the word is a real English word
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    private func wordError(message: String) {
        // Show an error message
        withAnimation {
            errorMessage = message
            showingError = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showingError = false
            }
        }
    }
    
    private func updateDefinitionState(word: String, definition: String) {
        // Update the state after successfully fetching word definition
        withAnimation {
            definitionIsLoading = false
            wordToBeDefined = word
            wordDefinition = definition
            showingDefinition = true
        }
    }
    
    private func handleDefinitionError(error: Error, for word: String) {
        // Handle errors occurred while fetching word definition
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
    
    // MARK: - Deinitializer
    
    deinit {
        // Cancel the timer when the object is deallocated
        timer?.cancel()
    }
}
