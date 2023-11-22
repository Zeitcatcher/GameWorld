//
//  ImageCacheManager.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/21/23.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
