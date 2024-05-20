//
//  ScoreScreen.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct SettingsScreen: View {
    @State private var wordLength: Int = 8
    @State private var selectedDuration: GameDuration = .oneAndHalfMinutes
    @State private var showProfile: Bool = false
    let appVersion = "1.0.0"
    
    var body: some View {
        Form {
            Section(header: Text("Game Settings")) {
                VStack(alignment: .leading) {
                    Text("Word Length: \(wordLength)")
                    Slider(value: Binding(
                        get: { Double(wordLength) },
                        set: { wordLength = Int($0) }
                    ), in: 6...12, step: 1)
                }
                
                Picker("Timer Length", selection: $selectedDuration) {
                    ForEach(GameDuration.allCases) { duration in
                        Text(duration.description).tag(duration)
                    }
                }
            }
            
            Section(header: Text("Profile")) {
                Button(action: {
                    showProfile.toggle()
                }) {
                    HStack {
                        Image(systemName: "person.circle")
                        Text("User Profile")
                    }
                }
                .sheet(isPresented: $showProfile) {
                    UserProfileView()
                }
            }
            
            Section(header: Text("App Information")) {
                HStack {
                    Text("App Version")
                    Spacer()
                    Text(appVersion)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct UserProfileView: View {
    var body: some View {
        VStack {
            Text("User Profile")
                .font(.largeTitle)
                .padding()
            
            // User profile details can be added here
            Text("Username: ExampleUser")
            Text("Email: example@example.com")
            
            Spacer()
        }
        .padding()
    }
}
