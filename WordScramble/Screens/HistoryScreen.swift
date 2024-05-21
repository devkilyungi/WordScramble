//
//  HistoryScreen.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI


struct GameHistory: Codable, Identifiable {
    var id = UUID()
    let rootWord: String
    let score: Int
    let duration: Int
    let date: Date
    var isHighScore: Bool
}

struct HistoryScreen: View {
    @EnvironmentObject private var viewModel: HomeScreenViewModel
    
    var body: some View {
        VStack {
            let history = viewModel.fetchGameHistory()
            
            if history.isEmpty {
                emptyHistoryView
            } else {
                ScrollView {
                    historyListView(history: history)
                }
            }
        }
        .navigationTitle("Game History")
    }
    
    private var emptyHistoryView: some View {
        VStack {
            Image(systemName: "tray")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding(.bottom, 10)
            
            Text("No history available")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            Text("Play a game to see your history here.")
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    private func historyListView(history: [GameHistory]) -> some View {
        let sortedHistory = history.sorted { $0.isHighScore && !$1.isHighScore }
        
        return ForEach(sortedHistory, id: \.id) { game in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Challenge:")
                        .font(.headline)
                    
                    Text("/\(game.rootWord)/")
                        .font(.body.italic())
                }
                
                HStack {
                    Text("Score:")
                        .font(.headline)
                    
                    Text("\(game.score)")
                        .font(.body)
                }
                
                HStack {
                    Text("Timer:")
                        .font(.headline)
                    
                    Text("\(styleTime(for: game.duration))")
                        .font(.body)
                    
                    Spacer()
                    
                    Text("\(game.date, formatter: DateFormatter.historyFormatter)")
                        .font(.caption)
                }
                
                if game.isHighScore {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "laurel.leading")
                        
                        Text("High Score")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "laurel.trailing")
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                }
            }
            .padding()
            .cardBackground()
        }
    }
    
    private func styleTime(for duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
