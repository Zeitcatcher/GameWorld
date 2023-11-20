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
//        setupViews()
    }
}

extension PlatformCollectionViewCell {
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
    
//    private func setupViews() {
//        // Configure platformImageView
//        platformImageView.contentMode = .scaleAspectFill
//        platformImageView.clipsToBounds = true
//        
//        // Configure platformLabel
//        platformLabel.font = UIFont.systemFont(ofSize: 20)
//        platformLabel.textAlignment = .center
//        platformLabel.numberOfLines = 0 // Allow multiple lines
//        
//        // Add platformImageView and platformLabel to the cell's contentView
//        contentView.addSubview(platformImageView)
//        contentView.addSubview(platformLabel)
//        let label = UILabel()
//        let imageView = UIImageView()
//        
//        // Define constraints
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: platformLabel.topAnchor, constant: -8),
//        ])
//        
//        platformImageView = imageView
//        
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        ])
//        
//        platformLabel = label
//    }
}
