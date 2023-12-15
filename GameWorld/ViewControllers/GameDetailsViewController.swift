//
//  GameDetailsViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/11/23.
//

import UIKit

class GameDetailsViewController: UIViewController {
    
    private var screenshotsScrollView = UIScrollView()
    private var screenshotsImageView = UIImageView()
    private var backgroundView = UIView()
    private var descriptionTextView = UITextView()
    private var images = [UIImageView]()
    
    var game: Game!
    
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
        setupScreenshotsScrollView()
//        setupScreenshotsImageView()
        setupBackgroundView()
        setupDescriptionTextView()
    }
    
    private func setupScreenshotsScrollView() {
        screenshotsScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        screenshotsScrollView.backgroundColor = .systemTeal
        screenshotsScrollView.contentSize = CGSize(width: screenshotsScrollView.contentSize.width, height: UIScreen.main.bounds.height*100)
        
        view.addSubview(screenshotsScrollView)
        
        addImages()
    }
    
    private func addImages() {
        for i in 0...10 {
            images.append(UIImageView(image: UIImage(systemName: "person.3.fill")))
            images[i].frame = CGRect(x: 0, y: UIScreen.main.bounds.height*CGFloat(i), width: view.frame.width, height: view.frame.height)
            images[i].contentMode = .scaleAspectFit
            screenshotsScrollView.addSubview(images[i])
        }
    }
    
    private func setupScreenshotsImageView() {
        imageURL = URL(string: game.backgroundImage ?? "")

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
        descriptionTextView.font = UIFont.systemFont(ofSize: 20)
        descriptionTextView.text =
        """
        Name: \(game.name)
        Release date: \(game.released)
        Test test
        """
        descriptionTextView.isEditable = false
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
