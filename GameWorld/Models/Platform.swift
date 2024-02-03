//
//  Platform.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

struct Platform: Codable, Hashable {
    let id: Int
    let name: String
    let backgroundImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case backgroundImageUrl = "image_background"
    }
}
