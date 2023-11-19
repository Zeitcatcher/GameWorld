//
//  PlatformCollectionViewCell.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

import UIKit

final class PlatformCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var platformImageView: UIImageView!
    @IBOutlet private weak var platformLabel: UILabel!
    
    private var imageURL: URL? {
        didSet {
            platformImageView.image = nil
//            updateImage()
        }
    }
    
    func configure(with platform: Platform) {
        platformLabel.text = platform.name
        imageURL = URL(string: platform.backgroundImageUrl)
        platformImageView.layer.cornerRadius = 20
    }
}
