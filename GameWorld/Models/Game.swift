//
//  Game.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

enum GamesUrl: String {
    case games = "https://api.rawg.io/api/games?key=2bc11399a7354494b1b6d068b5a7506b"
}

struct Game: Codable {
    let id: Int
    let name, released: String
    let backgroundImage: String
    let rating: Double
    let ratingTop: Int
    let ratingsCount: Int
    let metacritic, playtime: Int
    let updated: String
    let reviewsCount: Int
    let platforms: [Platform]
    let genres: [Genre]
    let stores: [Store]
    let esrbRating: EsrbRating
    let shortScreenshots: [ShortScreenshot]

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratingsCount = "ratings_count"
        case metacritic, playtime
        case updated
        case reviewsCount = "reviews_count"
        case platforms
        case genres, stores
        case esrbRating = "esrb_rating"
        case shortScreenshots = "short_screenshots"
    }
}
