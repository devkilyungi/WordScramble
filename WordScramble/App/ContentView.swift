//
//  ContentView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 19/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(
            path: $router.navPath,
            root: {
                HomeScreen()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .settings:
                            SettingsScreen()
                        case .history:
                            HistoryScreen()
                        case .profile:
                            UserProfile()
                        }
                    }
            }
        )
    }
}

#Preview {
    ContentView()
}
