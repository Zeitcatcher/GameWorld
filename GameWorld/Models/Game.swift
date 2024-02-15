//
//  Game.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

struct Game: Codable, Equatable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        return 
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.released == rhs.released &&
            lhs.backgroundImage == rhs.backgroundImage &&
            lhs.shortScreenshots == rhs.shortScreenshots &&
            lhs.description == rhs.description
    }
    
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let shortScreenshots: [ShortScreenshot]?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, name, released, description
        case backgroundImage = "background_image"
        case shortScreenshots = "short_screenshots"
    }
}
