//
//  Paltform.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

enum PlatformUrl: String {
    case platform = "https://api.rawg.io/api/platforms?key=2bc11399a7354494b1b6d068b5a7506b"
}

struct Platform: Codable {
    let id: Int
    let name: String
    let gamesCount: Int
    let backgroundImageUrl: String
    let yearStart: Int?
    let games: [Game]

    enum CodingKeys: String, CodingKey {
        case id, name, games
        case gamesCount = "games_count"
        case backgroundImageUrl = "image_background"
        case yearStart = "year_start"
    }
}
