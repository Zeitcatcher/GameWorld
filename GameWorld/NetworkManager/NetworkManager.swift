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
    
    //дублирование кода, правильно ли? Или это делать через запрос из VC?
    func fetchPlatforms(completion: @escaping(Result<Platform, NetworkError>) -> Void) {
        fetch(Platform.self, from: JsonURL.platform.rawValue) { result in
            switch result {
            case .success(let photoCollection):
                completion(.success(photoCollection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchGames(completion: @escaping(Result<Platform, NetworkError>) -> Void) {
        fetch(Platform.self, from: JsonURL.game.rawValue) { result in
            switch result {
            case .success(let photoCollection):
                completion(.success(photoCollection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func fetch<T: Decodable>(_ type: T.Type, from url: String, complition: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            complition(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
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
