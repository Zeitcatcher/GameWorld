//
//  NetworkManager.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

import Foundation

enum JsonURL: String {
    case platform = "https://api.rawg.io/api/platforms?key=2bc11399a7354494b1b6d068b5a7506b"
    case game = "https://api.rawg.io/api/games?key=2bc11399a7354494b1b6d068b5a7506b"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
//    func fetchPlatforms(completion: @escaping(Result<PlatformsCollection, NetworkError>) -> Void) {
//        fetch(PlatformsCollection.self, from: JsonURL.platform.rawValue) { result in
//            switch result {
//            case .success(let platformsCollection):
//                completion(.success(platformsCollection))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func fetchGames(completion: @escaping(Result<GamesCollection, NetworkError>) -> Void) {
        fetch(GamesCollection.self, from: JsonURL.game.rawValue) { result in
            switch result {
            case .success(let gamesCollection):
                let filteredGames = gamesCollection.games.filter { $0.platforms != nil && $0.backgroundImage != nil }
                let filteredCollection = GamesCollection(games: filteredGames)
                print("Games fetched successfuly in NetworkManager")
                completion(.success(filteredCollection))
            case .failure(let error):
                completion(.failure(error))
                print("Error fetching Games in NetworkManager")
            }
        }
    }
    
    
    private func fetch<T: Decodable>(_ type: T.Type, from url: String, complition: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            complition(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Вывод всего Json для поиска ошибки
//            if let data = data {
//                let responseString = String(data: data, encoding: .utf8)
//                print("Response String: \(responseString ?? "nil")")
//            }
            
            guard let data = data else {
                complition(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    complition(.success(type))
                }
            } catch let error {
                print("Decoding Error: \(error)")
                complition(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, complition: @escaping(Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                complition(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                complition(.success(imageData))
            }
        }
    }
}
