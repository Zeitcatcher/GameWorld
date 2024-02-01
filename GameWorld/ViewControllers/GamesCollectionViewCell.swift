//
//  GamesCollectionViewCell.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/2/23.
//

import UIKit
import Kingfisher

final class GamesCollectionViewCell: UICollectionViewCell {
    private var gameImageView = UIImageView()
    private var gameLabel = UILabel()
    
    private var imageURL: URL? {
        didSet {
            updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with game: Game) {
        gameLabel.text = "\(game.name)\n\(game.released ?? "n/a")"
        imageURL = URL(string: game.backgroundImage ?? "")
    }
    
    private func setupViews() {
        setupImageView()
        setupLabel()
    }
    
    private func setupImageView() {
        gameImageView.layer.cornerRadius = 20
        gameImageView.contentMode = .scaleAspectFill
        gameImageView.clipsToBounds = true
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(gameImageView)
    }
    
    private func setupLabel() {
        gameLabel.numberOfLines = 2
        gameLabel.layer.cornerRadius = 5
        gameLabel.backgroundColor = .white
        gameLabel.textAlignment = .center
        gameLabel.clipsToBounds = true
        gameLabel.font = UIFont.systemFont(ofSize: 16)
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(gameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gameImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -40),
            
            gameLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor),
            gameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func updateImage() {
        gameImageView.kf.cancelDownloadTask()
        if let imageURL {
            gameImageView.kf.setImage(with: Source.network(KF.ImageResource(downloadURL: imageURL)), options: .some([.transition(.fade(0.5))]))
        }
    }
}
