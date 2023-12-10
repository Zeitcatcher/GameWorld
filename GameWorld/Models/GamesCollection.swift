//
//  GamesCollection.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/2/23.
//

struct GamesCollection: Codable {
    let games: [Game]
    
    enum CodingKeys: String, CodingKey {
        case games = "results"
    }
}
