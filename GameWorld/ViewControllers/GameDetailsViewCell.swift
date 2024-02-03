//
//  GameDetailsViewCellCollectionViewCell.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/16/23.
//

import UIKit
import Kingfisher

final class GameDetailsViewCell: UICollectionViewCell {
    private var screenshotImageView = UIImageView()
    
    private var imageURL: URL? {
        didSet {
            screenshotImageView.image = nil
            updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with screenshot: ShortScreenshot?) {
        imageURL = URL(string: screenshot?.image ?? "")
    }
    
    // MARK: - Setup and Update Methods
    private func updateImage() {
        screenshotImageView.kf.cancelDownloadTask()

        guard let imageURL = imageURL else { return }
        screenshotImageView.kf.setImage(
            with: imageURL,
            placeholder: nil,
            options: [.transition(.fade(0.5))]
        )
    }
    
    private func setupImageView() {
        screenshotImageView.contentMode = .scaleAspectFill
        screenshotImageView.clipsToBounds = true
        screenshotImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(screenshotImageView)
        
        NSLayoutConstraint.activate([
            screenshotImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            screenshotImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            screenshotImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            screenshotImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
