//
//  UserProfile.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

struct UserProfile: View {
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

#Preview {
    UserProfile()
}
