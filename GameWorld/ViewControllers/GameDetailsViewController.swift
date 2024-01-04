//
//  GameDetailsViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 12/11/23.
//

import UIKit

class GameDetailsViewController: UIViewController {
    
    private var screenshotsCollectionView: UICollectionView!
    private var descriptionScrollView: UIScrollView!
    private var contentView = UIView()
    private var gameDetailsLabel = UILabel()
    private var pcRequirementsLabel = UILabel()
    private var screenshotsPageControl = UIPageControl()
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        setupScreenshotsCollectionView()
        setupDescriptionScrollView()
        setupScreenshotsPageControl()
    }
    
    private func setupScreenshotsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        screenshotsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        screenshotsCollectionView.isPagingEnabled = true //enables instagram like scrolling of items in UICollectionView
        screenshotsCollectionView.register(GameDetailsViewCell.self, forCellWithReuseIdentifier: "screenshotCell")
        screenshotsCollectionView.delegate = self
        screenshotsCollectionView.dataSource = self
        screenshotsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(screenshotsCollectionView)
        
        NSLayoutConstraint.activate([
            screenshotsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            screenshotsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenshotsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenshotsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])
    }
    
    private func setupScreenshotsPageControl() {
        screenshotsPageControl.numberOfPages = game.shortScreenshots.count
        screenshotsPageControl.currentPage = 0
        screenshotsPageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(screenshotsPageControl)
        
        NSLayoutConstraint.activate([
            screenshotsPageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenshotsPageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenshotsPageControl.bottomAnchor.constraint(equalTo: descriptionScrollView.topAnchor, constant: -5),
            screenshotsPageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    private func setupDescriptionScrollView() {
        descriptionScrollView = UIScrollView()
        descriptionScrollView.backgroundColor = .white
        descriptionScrollView.layer.cornerRadius = 20
        descriptionScrollView.showsHorizontalScrollIndicator = false
        descriptionScrollView.isDirectionalLockEnabled = true
        descriptionScrollView.translatesAutoresizingMaskIntoConstraints = false
        
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
            contentView.topAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.bottomAnchor, constant: -10),
            contentView.centerXAnchor.constraint(equalTo: descriptionScrollView.centerXAnchor)
        ])
        
        setupGameDetailsLabel()
        setupPcRequirementsLabel()
    }
    
    private func setupGameDetailsLabel() {
        gameDetailsLabel.font = .systemFont(ofSize: 20)
        gameDetailsLabel.numberOfLines = 20
        gameDetailsLabel.text =
        """
        Title: \(game.name)
        Release date: \(game.released)
        """
        
        gameDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(gameDetailsLabel)
        
        NSLayoutConstraint.activate([
            gameDetailsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            gameDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            gameDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            gameDetailsLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupPcRequirementsLabel() {
        pcRequirementsLabel.isHidden = true
        pcRequirementsLabel.font = .systemFont(ofSize: 20)
        pcRequirementsLabel.numberOfLines = 0
        pcRequirementsLabel.sizeToFit()
        pcRequirementsLabel.lineBreakMode = .byWordWrapping
        
        var pcRequirements = ""
//        game.platforms?.forEach({ platform in
//            if platform.requirements != nil {
//                pcRequirements = platform.requirements?.minimum ?? ""
//                pcRequirementsLabel.isHidden = false
//            }
//        })
        
        let styledHtmlString = styleHtmlString(with: pcRequirements)
        
        if let attributedString = convertToAttributedString(with: styledHtmlString) {
            pcRequirementsLabel.attributedText = attributedString
        }
        
        pcRequirementsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pcRequirementsLabel)
        
        NSLayoutConstraint.activate([
            pcRequirementsLabel.topAnchor.constraint(equalTo: gameDetailsLabel.bottomAnchor, constant: 10),
            pcRequirementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            pcRequirementsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            pcRequirementsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16)
        ])
    }
    
    //Convert HTML text into readable String
    private func convertToAttributedString(with htmlString: String) -> NSAttributedString? {
        guard let data = htmlString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }
    
    //Change font size and style in HTML code received
    private func styleHtmlString(with htmlString: String) -> String {
        let styledHtml = """
        <style>
            body { 
                font-size: 20px;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            }
        </style>
        \(htmlString)
        """
        return styledHtml
    }
}

//MARK: - UICollectionViewDataSource
extension GameDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        game.shortScreenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "screenshotCell",
                for: indexPath
            ) as? GameDetailsViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: game.shortScreenshots[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension GameDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    //Switches pages on the UIPageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        screenshotsPageControl.currentPage = Int(scrollView.contentOffset.x / width)
    }
}
