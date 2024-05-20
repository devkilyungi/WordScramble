//
//  DictionaryApi.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 19/05/2024.
//

import Foundation

struct WordDefinition: Codable {
    struct Meaning: Codable {
        struct Definition: Codable {
            let definition: String
        }
        let definitions: [Definition]
    }
    let meanings: [Meaning]?
}

struct DictionaryAPI {
    func fetchDefinition(for word: String) async throws -> String {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let decodedResponse = try? JSONDecoder().decode([WordDefinition].self, from: data),
              let definition = decodedResponse.first?.meanings?.first?.definitions.first?.definition else {
            throw NSError(domain: "No definition found", code: 404, userInfo: nil)
        }
        
        return definition
    }
}
