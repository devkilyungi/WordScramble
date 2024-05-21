//
//  Router.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 20/05/2024.
//

import SwiftUI

final class Router: ObservableObject {
    @Published var navPath = NavigationPath()
    
    public enum Destination: Codable, Hashable {
        case settings
        case history
    }
    
    func navigate(to destination: Destination) {
        DispatchQueue.main.async {
            self.navPath.append(destination)
        }
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        if !navPath.isEmpty {
            navPath.removeLast(navPath.count)
        }
    }
}
