//
//  NetworkManager.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

import Foundation

enum JSONURL: String {
    case base = "https://api.rawg.io/api/"
    case platform = "https://api.rawg.io/api/platforms?key=2bc11399a7354494b1b6d068b5a7506b"
    case game = "https://api.rawg.io/api/games?key=2bc11399a7354494b1b6d068b5a7506b"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}


struct Payload<Data: Decodable>: Decodable {
    let results: Data
}

// ViewController -> GamesService -> NetworkManager

protocol NetworkManager {
    func fetch<Model: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<Payload<Model>, Error>) -> Void)
}

final class NetworkManagerImpl: NetworkManager {
    init() {}
    
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
    
    func fetch<Model: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<Model, Error>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // Вывод всего Json для поиска ошибки
//            if let data = data {
//                let responseString = String(data: data, encoding: .utf8)
//                print("Response String: \(responseString ?? "nil")")
//            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let type = try decoder.decode(Model.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch let error {
                print("Decoding Error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError))
                }
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
