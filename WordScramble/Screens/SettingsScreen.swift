//
//  ScoreScreen.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct SettingsScreen: View {
    
    @EnvironmentObject private var viewModel: HomeScreenViewModel
    @EnvironmentObject private var router: Router
    
    @State private var selectedDuration: GameDuration = .oneAndHalfMinutes
    @State private var showProfile: Bool = false
    
    let appVersion = "1.0.0"
    
    var body: some View {
        Form {
            gameSettingsSection
            historySection
            appInformationSection
        }
        .navigationTitle("Settings")
    }
    
    private var gameSettingsSection: some View {
        Section(header: Text("Preferences")) {
            VStack(alignment: .leading) {
                Text("Word Length: \(viewModel.wordSize.rawValue)")
                
                Slider(value: Binding(
                    get: { Double(viewModel.wordSize.rawValue) },
                    set: {
                        if let length = WordLength(rawValue: Int($0)) {
                            viewModel.wordSize = length
                            UserDefaults.standard.set(length.rawValue, forKey: "WordSize")
                        } else {
                            print("Not a valid enum raw value")
                        }
                    }
                ), in: 6...12, step: 1)
            }
            
            Picker("Timer Length", selection: $viewModel.gameDuration) {
                ForEach(GameDuration.allCases) { duration in
                    Text(duration.description).tag(duration)
                }
            }
            .onChange(of: viewModel.gameDuration, {
                UserDefaults.standard.set(viewModel.gameDuration.rawValue, forKey: "GameDuration")
            })
            
            Text("Changes will reflect when you start a new game.")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
    
    private var historySection: some View {
        Section(header: Text("History")) {
            Button(action: {
                router.navigate(to: .history)
            }) {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                    
                    Text("View My History")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                }
            }
            .tint(.primary)
        }
    }
    
    private var appInformationSection: some View {
        Section(header: Text("App Information")) {
            HStack {
                Text("App Version")
                Spacer()
                Text(appVersion)
                    .foregroundColor(.gray)
            }
        }
    }
}
