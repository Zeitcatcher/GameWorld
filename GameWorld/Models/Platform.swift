//
//  Platform.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

struct Platform: Codable, Hashable {
    
//    let id: Int
    let name: String
//    let gamesCount: Int
    let backgroundImageUrl: String?
//    let yearStart: Int?
//    let games: [Game]

    enum CodingKeys: String, CodingKey {
        case /*id,*/ name/*, games*/
//        case gamesCount = "games_count"
        case backgroundImageUrl = "image_background"
//        case yearStart = "year_start"
    }
    
//    static func == (lhs: Platform, rhs: Platform) -> Bool {
//        lhs.name == rhs.name // Add other properties if needed for equality check
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name) // Add other properties if used in `==` for equality check
//    }
}
