//
//  PlatformCollection.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

struct PlatformCollection: Codable {
    let platforms: [Platform]
    
    enum CodingKeys: String, CodingKey {
        case platforms = "results"
    }
}
