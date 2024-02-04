//
//  NetworkManager.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

struct Payload<Data: Decodable>: Decodable {
    let results: Data
}

protocol NetworkManager {
    func fetch<Model: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<Payload<Model>, Error>) -> Void)
    func fetchGames(platform: Platform?, completion: @escaping(Result<[Game], Error>) -> Void)
    func fetchGame(gameName: String, completion: @escaping(Result<[Game], Error>) -> Void)
    func fetchPlatforms(completion: @escaping(Result<[Platform], Error>) -> Void)
    func fetchGameDescription(gameID: Int, completion: @escaping(Result<Game, Error>) -> Void)
}

final class NetworkManagerImpl: NetworkManager {
    
    private enum URLBuildingError: Error {
        case invalidURL
    }
    
    private enum Endpoint {
        case games(Platform?)
        case platforms
        case game(name: String)
        case description(gameID: Int)
    }
    
    init() {}
    
    func fetch<Model: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<Model, Error>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
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
                completion(.success(payload.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchGameDescription(gameID: Int, completion: @escaping (Result<Game, Error>) -> Void) {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try self.urlRequest(for: .description(gameID: gameID))
        } catch {
            completion(.failure(error))
            return
        }
        
        fetch(urlRequest: urlRequest) { (result: Result<Game, Error>) in
            switch result {
            case .success(let payload):
                completion(.success(payload))
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
        case .description(let gameID):
            components.path = "/api/games/\(gameID)"
        }
        
        components.queryItems = queryItems
        guard let url = components.url else {
            throw URLBuildingError.invalidURL
        }
        
        return URLRequest(url: url)
    }
}
