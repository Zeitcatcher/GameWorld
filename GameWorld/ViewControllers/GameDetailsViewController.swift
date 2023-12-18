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
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        setupScreenshotsCollectionView()
        setupDescriptionScrollView()
    }
    
    private func setupScreenshotsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        screenshotsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    private func setupDescriptionScrollView() {
        descriptionScrollView = UIScrollView()
        descriptionScrollView.backgroundColor = .white
        descriptionScrollView.layer.cornerRadius = 20
        descriptionScrollView.showsHorizontalScrollIndicator = false
        descriptionScrollView.isDirectionalLockEnabled = true
        descriptionScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionScrollView)
        
        NSLayoutConstraint.activate([
            descriptionScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            descriptionScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
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
            contentView.bottomAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.bottomAnchor),
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
        pcRequirementsLabel.font = .systemFont(ofSize: 20)
        pcRequirementsLabel.numberOfLines = 0
        pcRequirementsLabel.sizeToFit()
        pcRequirementsLabel.lineBreakMode = .byWordWrapping
        pcRequirementsLabel.text =
        """
        Title: \(game.name)
        Release date: \(game.released)
        """
        
        pcRequirementsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pcRequirementsLabel)
        
        NSLayoutConstraint.activate([
            pcRequirementsLabel.topAnchor.constraint(equalTo: gameDetailsLabel.bottomAnchor, constant: 10),
            pcRequirementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            pcRequirementsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            pcRequirementsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16)
        ])
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
}
