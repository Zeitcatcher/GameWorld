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
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with screenshot: ShortScreenshot?) {
        imageURL = URL(string: screenshot?.image ?? "")
    }
    
    //MARK: - Private methods
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        screenshotImageView.kf.setImage(with: Source.network(KF.ImageResource(downloadURL: imageURL)), options: .some([.transition(.fade(0.5))]))
    }
    
    private func setupViews() {
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
