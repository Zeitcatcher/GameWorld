//
//  Platform.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

struct Platform: Codable {
//    let id: Int
    let name: String
//    let gamesCount: Int
    let backgroundImageUrl: String
//    let yearStart: Int?
//    let games: [Game]

    enum CodingKeys: String, CodingKey {
        case name
//        case gamesCount = "games_count"
        case backgroundImageUrl = "image_background"
//        case yearStart = "year_start"
    }
}
