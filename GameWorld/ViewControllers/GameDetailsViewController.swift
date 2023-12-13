//
//  GameDetailsViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/11/23.
//

import UIKit

class GameDetailsViewController: UIViewController {
    
    private var screenshotsImageView: UIImageView!
    private var backgroundView: UIView!
    private var descriptionTextView: UITextView!
    
    private var imageURL: URL? {
        didSet {
            screenshotsImageView.image = nil
            updateImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        setupScreenshotsImageView()
        setupBackgroundView()
        setupDescriptionTextView()
    }
    
    private func setupScreenshotsImageView() {
        
    }
    
    private func setupBackgroundView() {
        
    }
    
    private func setupDescriptionTextView() {
        
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        
        getImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                self.screenshotsImageView.image = image
            case .failure(let error):
                print(error)
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
