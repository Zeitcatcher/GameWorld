//
//  GameDetailsViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/11/23.
//

import UIKit

class GameDetailsViewController: UIViewController {
    private let networkManager: NetworkManagerProtocol = NetworkManagerImpl()
    
    private lazy var screenshotsCollectionView: UICollectionView = createScreenshotsCollectionView()
    private lazy var descriptionScrollView: UIScrollView = createDescriptionScrollView()
    private var contentView = UIView()
    private var gameDetailsLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var screenshotsPageControl = UIPageControl()
    
    private var gameDescription = ""
    
    var selectedGame: Game?
    var tappedGameName: String = ""
    var tappedGameID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)
        fetchGameDetails()
    }
    
    //MARK: - Private methods
    private func fetchGameDetails() {
        networkManager.fetchGame(gameName: tappedGameName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let game):
                self.selectedGame = game.first
                self.fetchGameDescription()
                self.setupUserInterface()
            case .failure(let error):
                print("Error fetching game details: \(error)")
            }
        }
    }
    
    private func setupUserInterface() {
        setupScreenshotsCollectionView()
        setupDescriptionScrollView()
        setupScreenshotsPageControl()
    }
    
    private func createScreenshotsCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(GameDetailsViewCell.self, forCellWithReuseIdentifier: "screenshotCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
    
    private func createDescriptionScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 20
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }
    
    private func setupScreenshotsCollectionView() {
        view.addSubview(screenshotsCollectionView)
        screenshotsCollectionView.backgroundColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)
        NSLayoutConstraint.activate([
            screenshotsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            screenshotsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenshotsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenshotsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])
    }
    
    private func setupDescriptionScrollView() {
        view.addSubview(descriptionScrollView)
        descriptionScrollView.backgroundColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)
        
        NSLayoutConstraint.activate([
            descriptionScrollView.topAnchor.constraint(equalTo: screenshotsCollectionView.bottomAnchor, constant: -15),
            descriptionScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupContentView()
    }
    
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        descriptionScrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.topAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.trailingAnchor, constant: -8),
            contentView.bottomAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.bottomAnchor, constant: -10),
            contentView.centerXAnchor.constraint(equalTo: descriptionScrollView.centerXAnchor)
        ])
        
        setupGameDetailsLabel()
    }
    
    private func setupGameDetailsLabel() {
        guard let game = selectedGame else { return }
        
        gameDetailsLabel.font = .systemFont(ofSize: 20)
        gameDetailsLabel.textColor = .white
        gameDetailsLabel.numberOfLines = 0
        gameDetailsLabel.text = "Title: \(game.name)\nRelease date: \(game.released ?? "Not available")"
        gameDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(gameDetailsLabel)
        
        NSLayoutConstraint.activate([
            gameDetailsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            gameDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            gameDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    private func fetchGameDescription() {
        networkManager.fetchGameDescription(gameID: tappedGameID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let game):
                self.gameDescription = game.description ?? ""
                setupDescriptionLabel()
            case .failure(let error):
                print("Error after Game fetch: \(error)")
            }
        }
    }
    
    private func setupDescriptionLabel() {
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let attributedString = convertToAttributedString(with: gameDescription)
            let styledHtmlString = styleHtmlString(htmlString: gameDescription)

            descriptionLabel.attributedText = attributedString
            
            if let attributedString = convertToAttributedString(with: styledHtmlString) {
                descriptionLabel.attributedText = attributedString
            }
        
            contentView.addSubview(descriptionLabel)
            
            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: gameDetailsLabel.bottomAnchor, constant: 10),
                descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
        }
    
    private func convertToAttributedString(with htmlString: String) -> NSAttributedString? {
        guard let data = htmlString.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }
    
    private func styleHtmlString(htmlString: String) -> String {
        let styledHtml = """
        <style>
            body {
                font-size: 20px;
                color: white
            }
        </style>
        \(htmlString)
        """
        return styledHtml
    }
    
    private func setupScreenshotsPageControl() {
        guard let game = selectedGame?.shortScreenshots else { return }
        
        screenshotsPageControl.numberOfPages = game.count
        screenshotsPageControl.currentPage = 0
        screenshotsPageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)
        screenshotsPageControl.pageIndicatorTintColor = .lightGray
        screenshotsPageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(screenshotsPageControl)
        
        NSLayoutConstraint.activate([
            screenshotsPageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenshotsPageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenshotsPageControl.bottomAnchor.constraint(equalTo: descriptionScrollView.topAnchor, constant: -5),
            screenshotsPageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension GameDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedGame?.shortScreenshots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshotCell", for: indexPath) as? GameDetailsViewCell,
              let screenshot = selectedGame?.shortScreenshots?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.configure(with: screenshot)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GameDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        screenshotsPageControl.currentPage = pageIndex
    }
}
