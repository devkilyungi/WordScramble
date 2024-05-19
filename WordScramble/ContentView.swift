//
//  ContentView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 19/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var showingDefinition = false
    @State private var wordDefinition = ""
    
    let dictionaryAPI = DictionaryAPI()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(rootWord)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.top, .horizontal])
                
                Text("Score: \(score)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding([.bottom, .horizontal])
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Enter a new word")
                        .font(.headline)
                    
                    HStack {
                        TextField("Enter your word", text: $newWord)
                            .foregroundColor(.primary).opacity(0.8)
                            .padding(10)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .strokeBorder(.secondary, style: StrokeStyle(lineWidth: 1.0))
                    )
                    
                    Text("Used Words")
                        .font(.headline)
                    
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                                .foregroundColor(.blue)
                            Text(word)
                                .onTapGesture {
                                    fetchDefinition(for: word)
                                }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("WordScrabble")
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .alert("Definition", isPresented: $showingDefinition) {
                Button("OK") { }
            } message: {
                Text(wordDefinition)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("New Game", action: startGame)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Restart", action: restartGame)
                }
            }
        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords = []
                newWord = ""
                score = 0
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func restartGame() {
        usedWords.removeAll()
        startGame()
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
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
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func fetchDefinition(for word: String) {
        dictionaryAPI.fetchDefinition(for: word) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let definition):
                    wordDefinition = definition
                    showingDefinition = true
                case .failure(let error):
                    wordError(title: "Definition not found", message: error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
