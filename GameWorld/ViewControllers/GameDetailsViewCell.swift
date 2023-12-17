//
//  GameDetailsViewCellCollectionViewCell.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/16/23.
//

import UIKit

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
    
    func configure(with screenshot: ShortScreenshot) {
        imageURL = URL(string: screenshot.image)
    }
    
    //MARK: - Private methods
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        
        getImage(from: imageURL) { [ weak self ] result in
            switch result {
            case .success(let image):
                self?.screenshotImageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getImage(from url: URL, complition: @escaping(Result<UIImage, Error>) -> Void) {
        if let caachedImage = ImageCacheManager.shared.object(forKey: url.lastPathComponent as NSString) {
            print("Image from cache: ", url.lastPathComponent)
            complition(.success(caachedImage))
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
