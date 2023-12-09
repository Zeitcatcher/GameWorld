//
//  GamesCollectionViewCell.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/2/23.
//

import UIKit

final class GamesCollectionViewCell: UICollectionViewCell {
    private var gameImageView = UIImageView()
    private var gameLabel = UILabel()
    
    private var imageURL: URL? {
        didSet {
            gameImageView.image = nil
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
    
    func configure(with game: Game) {
        gameLabel.text = game.name
        gameLabel.layer.cornerRadius = 5
        gameLabel.backgroundColor = .gray
        gameLabel.clipsToBounds = true
        
        imageURL = URL(string: game.backgroundImage ?? "")
        
        gameImageView.layer.cornerRadius = 20
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        getImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                print("Image received GamesVC Cell")
                self.gameImageView.image = image
            case .failure(let error):
                print(error)
                print("Image not received GamesVC Cell")
            }
        }
        
    }
    
    private func getImage(from url: URL, complition: @escaping(Result<UIImage, Error>) -> Void) {
        if let cachedImage = ImageCacheManager.shared.object(forKey: url.lastPathComponent as NSString) {
            print("Image from cache: ", url.lastPathComponent)
            complition(.success(cachedImage))
            return
        }
        
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                guard let uiImage = UIImage(data: imageData) else { return }
                ImageCacheManager.shared.setObject(uiImage, forKey: url.lastPathComponent as NSString)
                print("Image from network: ", url.lastPathComponent)
                complition(.success(uiImage))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupViews() {
        contentView.addSubview(gameLabel)
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameImageView.contentMode = .scaleAspectFill
        gameImageView.clipsToBounds = true
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(gameImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -8),
            gameImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -2),

            gameLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor),
            gameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameLabel.widthAnchor.constraint(equalTo: gameImageView.widthAnchor),
            gameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
