//
//  PlatformCollection.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

struct PlatformDetails: Codable {
    let platform: Platform
    let requirements: DesktopRequirements?
    
    enum CodingKeys: String, CodingKey {
        case platform
        case requirements = "requirements_en"
    }
}

