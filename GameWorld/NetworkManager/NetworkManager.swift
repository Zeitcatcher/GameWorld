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
    func fetchGames(platform: Platform?, completion: @escaping(Result<[Game], Error>) -> Void)
    func fetchGame(gameName: String, completion: @escaping(Result<[Game], Error>) -> Void)
    func fetchPlatforms(completion: @escaping(Result<[Platform], Error>) -> Void)
}

final class NetworkManagerImpl: NetworkManager {
    
    private enum URLBuildingError: Error {
        case invalidURL
    }
    
    private enum Endpoint {
        case games(Platform?)
        case platforms
        case game(name: String)
    }
    
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
    
    func fetchGames(platform: Platform?, completion: @escaping (Result<[Game], Error>) -> Void) {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try self.urlRequest(for: .games(platform))
        } catch {
            completion(.failure(error))
            return
        }
        
        fetch(urlRequest: urlRequest) { (result: Result<Payload<[Game]>, Error>) in
            switch result {
            case .success(let payload):
//                let filteredGames = payload.results.filter { $0.platforms != nil && $0.backgroundImage != nil }
                completion(.success(payload.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchGame(gameName: String, completion: @escaping (Result<[Game], Error>) -> Void) {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try self.urlRequest(for: .game(name: gameName))
        } catch {
            completion(.failure(error))
            return
        }
        
        fetch(urlRequest: urlRequest) { (result: Result<Payload<[Game]>, Error>) in
            switch result {
            case .success(let payload):
//                let filteredGames = payload.results.filter { $0.platforms != nil && $0.backgroundImage != nil }
                completion(.success(payload.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlatforms(completion: @escaping (Result<[Platform], Error>) -> Void) {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try self.urlRequest(for: .platforms)
        } catch {
            completion(.failure(error))
            return
        }
        
        fetch(urlRequest: urlRequest) { (result: Result<Payload<[Platform]>, Error>) in
            switch result {
            case .success(let payload):
                completion(.success(payload.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
//    func fetchImage(from url: URL, complition: @escaping(Result<Data, NetworkError>) -> Void) {
//        DispatchQueue.global().async {
//            guard let imageData = try? Data(contentsOf: url) else {
//                complition(.failure(.noData))
//                return
//            }
//            DispatchQueue.main.async {
//                complition(.success(imageData))
//            }
//        }
//    }
    
    //MARK: - Private Methods
    private func urlRequest(for endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "api.rawg.io"
        
        var queryItems = [
            URLQueryItem(name: "key", value: "2bc11399a7354494b1b6d068b5a7506b")
        ]
        
        switch endpoint {
        case .games(let platform):
            components.path = "/api/games"
            if let platform {
                queryItems.append(URLQueryItem(name: "platforms", value: String(platform.id)))
            }
        case .platforms:
            components.path = "/api/platforms"
        case .game(let name):
            components.path = "/api/games"
            queryItems.append(URLQueryItem(name: "search", value: name))
            print("------------------ queryItems: \(queryItems)")
        }
        
        
        components.queryItems = queryItems
        print("------------------ \(components)")
        guard let url = components.url else {
            throw URLBuildingError.invalidURL
        }
        
        return URLRequest(url: url)
    }
}
