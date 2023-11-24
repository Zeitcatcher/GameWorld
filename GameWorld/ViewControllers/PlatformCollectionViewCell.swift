//
//  PlatformCollectionViewCell.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

import UIKit

final class PlatformCollectionViewCell: UICollectionViewCell {
    private var platformImageView = UIImageView()
    private var platformLabel = UILabel()
    
    private var imageURL: URL? {
        didSet {
            platformImageView.image = nil
            updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with platform: Platform) {
        platformLabel.text = platform.name
        imageURL = URL(string: platform.backgroundImageUrl)
        platformImageView.layer.cornerRadius = 20
        platformLabel.backgroundColor = .gray
        platformLabel.layer.cornerRadius = 20
        platformLabel.clipsToBounds = true
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
        if let cachedImage = ImageCacheManager.shared.object(forKey: url.lastPathComponent as NSString) {
            print("Image from cache: ", url)
            complition(.success(cachedImage))
            return
        }
        
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                guard let uiImage = UIImage(data: imageData) else { return }
                ImageCacheManager.shared.setObject(uiImage, forKey: url.lastPathComponent as NSString)
                print("Image from network: ", url)
                complition(.success(uiImage))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupViews() {
        platformImageView.contentMode = .scaleAspectFill
        platformImageView.clipsToBounds = true
        platformImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(platformImageView)

        platformLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(platformLabel)

        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            platformImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            platformImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            platformImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.85),
            platformImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            platformLabel.topAnchor.constraint(equalTo: platformImageView.bottomAnchor),
            platformLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            platformLabel.widthAnchor.constraint(equalTo: platformImageView.widthAnchor),
            platformLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
