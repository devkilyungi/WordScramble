//
//  WordScrambleApp.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 19/05/2024.
//

import SwiftUI

@main
struct WordScrambleApp: App {
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
    }
}
