//
//  GamesService.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/25/23.
//

import Foundation

protocol Service {
    func fetchGames(platform: Platform?, completion: @escaping(Result<[Game], Error>) -> Void)
    func fetchPlatforms(completion: @escaping(Result<[Platform], Error>) -> Void)
}

final class ServiceImpl: Service {
    private enum URLBuildingError: Error {
        case invalidURL
    }
    
    private enum Endpoint {
        case games(Platform?)
        case platforms
    }
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchGames(platform: Platform?, completion: @escaping (Result<[Game], Error>) -> Void) {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try self.urlRequest(for: .games(platform))
        } catch {
            completion(.failure(error))
            return
        }
        
        networkManager.fetch(urlRequest: urlRequest) { (result: Result<Payload<[Game]>, Error>) in
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
        
        networkManager.fetch(urlRequest: urlRequest) { (result: Result<Payload<[Platform]>, Error>) in
            switch result {
            case .success(let payload):
                completion(.success(payload.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    
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
        }
        
        
        components.queryItems = queryItems
    
        guard let url = components.url else {
            throw URLBuildingError.invalidURL
        }
        
        return URLRequest(url: url)
    }
}
