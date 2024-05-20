//
//  WordDatabase.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import Foundation
import SQLite

class WordDatabase {
    private var db: Connection?

    init() {
        setupDatabase()
        createTablesIfNeeded()
        loadWordsIfNeeded()
    }

    private func setupDatabase() {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let databaseURL = documentDirectory.appendingPathComponent("words.sqlite3")
            if !fileManager.fileExists(atPath: databaseURL.path) {
                if let bundleURL = Bundle.main.url(forResource: "words", withExtension: "sqlite3") {
                    try? fileManager.copyItem(at: bundleURL, to: databaseURL)
                }
            }
            db = try? Connection(databaseURL.path)
        }
    }

    private func createTablesIfNeeded() {
        guard let db = db else { return }
        
        let wordLengths = [
            "six_letter_words",
            "seven_letter_words",
            "eight_letter_words",
            "nine_letter_words",
            "ten_letter_words",
            "eleven_letter_words",
            "twelve_letter_words"
        ]
        
        for tableName in wordLengths {
            let table = Table(tableName)
            let wordColumn = Expression<String>("word")
            
            do {
                try db.run(table.create(ifNotExists: true) { t in
                    t.column(wordColumn, primaryKey: true)
                })
            } catch {
                print("Error creating table \(tableName): \(error)")
            }
        }
    }

    private func loadWords(from filename: String, startIndex: Int, batchSize: Int) -> [String]? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let allWords = try JSONDecoder().decode([String].self, from: data)
            let endIndex = min(startIndex + batchSize, allWords.count)
            return Array(allWords[startIndex..<endIndex])
        } catch {
            print("Error loading words from \(filename): \(error)")
            return nil
        }
    }

    private func loadWordsIfNeeded() {
        guard let db = db else { return }
        
        do {
            let wordLengths = [
                6: "six_letter_words",
                7: "seven_letter_words",
                8: "eight_letter_words",
                9: "nine_letter_words",
                10: "ten_letter_words",
                11: "eleven_letter_words",
                12: "twelve_letter_words"
            ]
            
            for (length, tableName) in wordLengths {
                let table = Table(tableName)
                let wordColumn = Expression<String>("word")
                
                // Check if the table is already populated
                let count = try db.scalar(table.count)
                if count == 0, let words = loadWords(from: "words_\(length)", startIndex: 0, batchSize: 5) {
                    for word in words {
                        try db.run(table.insert(or: .ignore, wordColumn <- word))
                    }
                }
            }
        } catch {
            print("Error loading words: \(error)")
        }
    }

    func getRandomWord(from tableName: String) -> String? {
        guard let db = db else { return nil }
        
        let table = Table(tableName)
        let wordColumn = Expression<String>("word")
        
        do {
            let count: Int = try db.scalar(table.count)
            if count > 0 {
                let randomOffset = Int.random(in: 0..<count)
                if let wordRow = try db.pluck(table.limit(1, offset: randomOffset)) {
                    return wordRow[wordColumn]
                }
            }
        } catch {
            print("Error fetching random word: \(error)")
        }
        return nil
    }
}
