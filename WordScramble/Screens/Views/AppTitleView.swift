//
//  AppTitle.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct AppTitleView: View {
    
    @ObservedObject var viewModel = HomeScreenViewModel()
    let parentWidth: CGFloat
    @EnvironmentObject private var router: Router
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Scramble")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                router.navigate(to: .settings)
            }) {
                Image(systemName: "gearshape")
                    .font(.title2)
            }
        }
        .frame(width: parentWidth * 0.9)
    }
}
