//
//  HistoryScreen.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct HistoryScreen: View {
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                
                HistoryItem(date: "May 15, 2024", score: 250, duration: "3 minutes")
                HistoryItem(date: "May 10, 2024", score: 180, duration: "2 minutes")
                HistoryItem(date: "May 5, 2024", score: 300, duration: "3 minutes")
                
                Spacer()
            }
        }
        .navigationTitle("Game History")
    }
}

struct HistoryItem: View {
    var date: String
    var score: Int
    var duration: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Date: \(date)")
                    .font(.headline)
                
                Text("Score: \(score)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Duration: \(duration)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(
            Color(UIColor.systemGray6)
                .cornerRadius(10)
        )
    }
}
