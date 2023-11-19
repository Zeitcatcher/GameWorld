//
//  Genre.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

struct Genre: Codable {
    let id: Int
    let name: String
    let gamesCount: Int
    let imageBackground: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
