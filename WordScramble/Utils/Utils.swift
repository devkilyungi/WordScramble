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
