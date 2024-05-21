//
//  GameHistory.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 21/05/2024.
//

import Foundation

struct GameHistory: Codable, Identifiable {
    var id = UUID()
    let rootWord: String
    let score: Int
    let duration: Int
    let date: Date
    var isHighScore: Bool
}

extension GameHistory {
    static func dummyData() -> GameHistory {
        return GameHistory(rootWord: "example", score: 100, duration: 90, date: Date(), isHighScore: false)
    }
}
