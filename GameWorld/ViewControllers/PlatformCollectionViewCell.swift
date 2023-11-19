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
            updateImage()
        }
    }
    
    func configure(with platform: Platform) {
        platformLabel.text = platform.name
        imageURL = URL(string: platform.backgroundImageUrl)
        platformImageView.layer.cornerRadius = 20
    }
}

extension PlatformCollectionViewCell {
    private func getImage(from url: URL, complition: @escaping(Result<UIImage, Error>) -> Void) {
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                guard let uiImage = UIImage(data: imageData) else { return }
                print("Image from network: ", url.lastPathComponent)
                complition(.success(uiImage))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        getImage(from: imageURL) { [weak self ] result in
            switch result {
            case .success(let image):
                self?.platformImageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
}
