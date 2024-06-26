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
    @StateObject private var mainViewModel = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(mainViewModel)
        }
    }
}
