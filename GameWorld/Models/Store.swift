//
//  Store.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

struct Store: Codable {
    let id: Int
    let name: String
    let gamesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case gamesCount = "games_count"
    }
}
