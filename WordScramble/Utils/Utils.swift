//
//  Utils.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import Foundation

extension DateFormatter {
    static var historyFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
