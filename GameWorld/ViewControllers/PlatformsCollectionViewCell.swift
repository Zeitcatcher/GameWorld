//
//  PlatformCollectionViewCell.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/18/23.
//

import UIKit
import Kingfisher

final class PlatformsCollectionViewCell: UICollectionViewCell {
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
        if let url = platform.backgroundImageUrl {
            imageURL = URL(string: url)
        }
    }
    
    //MARK: Private methods
    private func setupViews() {
        configureImageView()
        configureLabel()
    }
    
    private func configureImageView() {
        platformImageView.contentMode = .scaleAspectFill
        platformImageView.layer.cornerRadius = 20
        platformImageView.clipsToBounds = true
        platformImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(platformImageView)
        
        NSLayoutConstraint.activate([
            platformImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            platformImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            platformImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.85),
            platformImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }

    private func configureLabel() {
        platformLabel.backgroundColor = UIColor.clear
        platformLabel.textColor = .white
        platformLabel.font = UIFont.systemFont(ofSize: 20)
        platformLabel.textAlignment = .center
        platformLabel.layer.cornerRadius = 20
        platformLabel.clipsToBounds = true
        platformLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(platformLabel)
        
        NSLayoutConstraint.activate([
            platformLabel.topAnchor.constraint(equalTo: platformImageView.bottomAnchor),
            platformLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            platformLabel.widthAnchor.constraint(equalTo: platformImageView.widthAnchor),
            platformLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func updateImage() {
        platformImageView.kf.cancelDownloadTask()

        guard let imageURL = imageURL else { return }
        platformImageView.kf.indicatorType = .activity
        platformImageView.kf.setImage(
            with: imageURL,
            placeholder: nil,
            options: [.transition(.fade(0.5))]
        )
    }
}
