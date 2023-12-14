//
//  GameDetailsViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/11/23.
//

import UIKit

class GameDetailsViewController: UIViewController {
    
    private var screenshotsImageView = UIImageView()
    private var backgroundView = UIView()
    private var descriptionTextView = UITextView()
    
    var game: Game!
    
    private var imageURL: URL? {
        didSet {
            screenshotsImageView.image = nil
            updateImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageURL = URL(string: game.backgroundImage ?? "")
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        setupScreenshotsImageView()
        setupBackgroundView()
        setupDescriptionTextView()
    }
    
    private func setupScreenshotsImageView() {
        screenshotsImageView.contentMode = .scaleAspectFill
        screenshotsImageView.clipsToBounds = true
        screenshotsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(screenshotsImageView)
        
        NSLayoutConstraint.activate([
            screenshotsImageView.topAnchor.constraint(equalTo: view.topAnchor),
            screenshotsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenshotsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenshotsImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])
    }
    
    private func setupBackgroundView() {
        backgroundView.layer.cornerRadius = 20
        backgroundView.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.font = UIFont.systemFont(ofSize: 40)
        descriptionTextView.text = "123 test test test"
        descriptionTextView.textContainer.maximumNumberOfLines = 2
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8),
            descriptionTextView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 8),
            descriptionTextView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 50),
            descriptionTextView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, constant: 0.5)
        ])
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        
        getImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                self.screenshotsImageView.image = image
                print("DetailsVC - Image fetched successfully")
            case .failure(let error):
                print(error)
                print("DetailsVC - Image not fetched")
            }
        }
    }
    
    private func getImage(from url: URL, complition: @escaping(Result<UIImage, Error>) -> Void) {
        if let cachedImage = ImageCacheManager.shared.object(forKey: url.lastPathComponent as NSString) {
            complition(.success(cachedImage))
            return
        }
        
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                guard let uiImage = UIImage(data: imageData) else { return }
                ImageCacheManager.shared.setObject(uiImage, forKey: url.lastPathComponent as NSString)
                complition(.success(uiImage))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}
