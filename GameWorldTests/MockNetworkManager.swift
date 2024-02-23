//
//  MockNetworkManager.swift
//  GameWorldTests
//
//  Created by Arseniy Oksenoyt on 2/7/24.
//

import Foundation
@testable import GameWorld

class MockNetworkManager: NetworkManagerProtocol {
    
    var shouldReturnError = false
    var mockedGames: [Game]?
    var mockedPlatforms: [Platform]?
    var mockedGameDescription: Game?
    
    func fetch<Model>(urlRequest: URLRequest, completion: @escaping (Result<GameWorld.Payload<Model>, Error>) -> Void) where Model : Decodable {
    }
    
    func fetchGames(platform: GameWorld.Platform?, completion: @escaping (Result<[GameWorld.Game], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NetworkError.decodingError))
        } else if let games = mockedGames, !games.isEmpty {
            completion(.success(games))
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
    
    func fetchGame(gameName: String, completion: @escaping (Result<[GameWorld.Game], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NetworkError.decodingError))
        } else if let game = mockedGames, !game.isEmpty {
            completion(.success(game))
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
    
    func fetchPlatforms(completion: @escaping (Result<[GameWorld.Platform], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NetworkError.decodingError))
        } else if let platforms = mockedPlatforms, !platforms.isEmpty {
            completion(.success(platforms))
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
    
    func fetchGameDescription(gameID: Int, completion: @escaping (Result<GameWorld.Game, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NetworkError.decodingError))
        } else if let gameDescription = mockedGameDescription {
            completion(.success(gameDescription))
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
}
