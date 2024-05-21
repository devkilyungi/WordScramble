//
//  Utils.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import Foundation

enum GameDuration: Int, CaseIterable, Identifiable {
    case blitz = 30
    case regular = 60
    case oneAndHalfMinutes = 90
    case twoMinutes = 120
    case threeMinutes = 180
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .blitz:
            return "Blitz (30 seconds)"
        case .regular:
            return "Regular (60 seconds)"
        case .oneAndHalfMinutes:
            return "90 seconds"
        case .twoMinutes:
            return "2 minutes"
        case .threeMinutes:
            return "3 minutes"
        }
    }
}

enum WordLength: Int {
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case eleven = 11
    case twelve = 12
    
    var wordForm: String {
        switch self {
        case .six: return "six"
        case .seven: return "seven"
        case .eight: return "eight"
        case .nine: return "nine"
        case .ten: return "ten"
        case .eleven: return "eleven"
        case .twelve: return "twelve"
        }
    }
}

extension DateFormatter {
    static var historyFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
