//
//  WordLength.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 21/05/2024.
//

import Foundation

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
