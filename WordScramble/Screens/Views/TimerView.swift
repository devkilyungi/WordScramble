//
//  TimerView.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: HomeScreenViewModel
    
    var body: some View {
        HStack {
            Text("Time remaining: ")
            Text(viewModel.formattedTimeRemaining)
                .font(.body)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
        }
    }
}
