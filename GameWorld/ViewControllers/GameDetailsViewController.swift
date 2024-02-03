//
//  GameDetailsViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/11/23.
//

import UIKit

class GameDetailsViewController: UIViewController {
    private let networkManager: NetworkManager = NetworkManagerImpl()
    
    private lazy var screenshotsCollectionView: UICollectionView = createScreenshotsCollectionView()
    private lazy var descriptionScrollView: UIScrollView = createDescriptionScrollView()
    private var contentView = UIView()
    private var gameDetailsLabel = UILabel()
    private var pcRequirementsLabel = UILabel()
    private var screenshotsPageControl = UIPageControl()
    
    private var gameDescription = "No text"
    
    var selectedGame: Game?
    var tappedGameName: String = ""
    var tappedGameID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)
        fetchGame()
    }
    
    //MARK: - Private methods
    private func fetchGame() {
        networkManager.fetchGame(gameName: tappedGameName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let game):
                print("Games fetched succesfully")
                self.selectedGame = game.first
                self.fetchDescription()
                self.setupUI()
            case .failure(let error):
                print("Error after Game fetch: \(error)")
            }
        }
    }
    
    private func setupUI() {
        setupScreenshotsCollectionView()
        setupDescriptionScrollView()
        setupScreenshotsPageControl()
    }
    
    private func createScreenshotsCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        screenshotsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        screenshotsCollectionView.isPagingEnabled = true
        screenshotsCollectionView.register(GameDetailsViewCell.self, forCellWithReuseIdentifier: "screenshotCell")
        screenshotsCollectionView.delegate = self
        screenshotsCollectionView.dataSource = self
        screenshotsCollectionView.showsHorizontalScrollIndicator = false
        screenshotsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return screenshotsCollectionView
    }
    
    private func createDescriptionScrollView() -> UIScrollView {
        descriptionScrollView = UIScrollView()
        descriptionScrollView.backgroundColor = .white
        descriptionScrollView.layer.cornerRadius = 20
        descriptionScrollView.showsHorizontalScrollIndicator = false
        descriptionScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionScrollView
    }
    
    private func setupScreenshotsCollectionView() {
        screenshotsCollectionView.backgroundColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)
        
        view.addSubview(screenshotsCollectionView)

        NSLayoutConstraint.activate([
            screenshotsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            screenshotsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenshotsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenshotsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])
    }
    
    private func setupScreenshotsPageControl() {
        guard let game = selectedGame?.shortScreenshots else { return}
        
        screenshotsPageControl.numberOfPages = game.count
        screenshotsPageControl.currentPage = 0
        screenshotsPageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)
        screenshotsPageControl.translatesAutoresizingMaskIntoConstraints = false
        screenshotsPageControl.pageIndicatorTintColor = .lightGray
        
        view.addSubview(screenshotsPageControl)
        
        NSLayoutConstraint.activate([
            screenshotsPageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenshotsPageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenshotsPageControl.bottomAnchor.constraint(equalTo: descriptionScrollView.topAnchor, constant: -5),
            screenshotsPageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupDescriptionScrollView() {
        descriptionScrollView.backgroundColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)
        
        view.addSubview(descriptionScrollView)
        
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
        gameDetailsLabel.numberOfLines = 20
        gameDetailsLabel.text = "Title: \(game.name)\nRelease date: \(game.released ?? "n/a")"
        gameDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(gameDetailsLabel)
        
        NSLayoutConstraint.activate([
            gameDetailsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            gameDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            gameDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupPcRequirementsLabel() {
        pcRequirementsLabel.numberOfLines = 0
        pcRequirementsLabel.lineBreakMode = .byWordWrapping
        pcRequirementsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = convertToAttributedString(with: gameDescription)
        let styledHtmlString = styleHtmlString(htmlString: gameDescription)

        pcRequirementsLabel.attributedText = attributedString
        
        if let attributedString = convertToAttributedString(with: styledHtmlString) {
            pcRequirementsLabel.attributedText = attributedString
        }
        print("Label: \(pcRequirementsLabel.text ?? "No text")")
        contentView.addSubview(pcRequirementsLabel)
        
        NSLayoutConstraint.activate([
            pcRequirementsLabel.topAnchor.constraint(equalTo: gameDetailsLabel.bottomAnchor, constant: 10),
            pcRequirementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            pcRequirementsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            pcRequirementsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func fetchDescription() {
        networkManager.fetchGameDescription(gameID: tappedGameID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let game):
                print("Games fetched succesfully")
                self.gameDescription = game.description ?? ""
                setupPcRequirementsLabel()
                print("Game Description: \(game.description ?? "")")
            case .failure(let error):
                print("Error after Game fetch: \(error)")
            }
        }
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
    
    private func convertToAttributedString(with htmlString: String) -> NSAttributedString? {
        guard let data = htmlString.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension GameDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let game = selectedGame?.shortScreenshots?.count else { return 0 }
        return game
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshotCell", for: indexPath) as? GameDetailsViewCell else {
            return UICollectionViewCell()
        }
        guard let game = selectedGame else { return UICollectionViewCell() }
        cell.configure(with: game.shortScreenshots?[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GameDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        screenshotsPageControl.currentPage = Int(scrollView.contentOffset.x / width)
    }
}
