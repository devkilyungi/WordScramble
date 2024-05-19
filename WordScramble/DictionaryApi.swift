//
//  DictionaryApi.swift
//  WordScramble
//
//  Created by Victor Kilyungi on 19/05/2024.
//

import Foundation

struct DictionaryAPI {
    func fetchDefinition(for word: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 400, userInfo: nil)))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode([WordDefinition].self, from: data)
                if let definition = decodedResponse.first?.meanings.first?.definitions.first?.definition {
                    completion(.success(definition))
                } else {
                    completion(.failure(NSError(domain: "No definition found", code: 404, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct WordDefinition: Codable {
    struct Meaning: Codable {
        struct Definition: Codable {
            let definition: String
        }
        let definitions: [Definition]
    }
    let meanings: [Meaning]
}
