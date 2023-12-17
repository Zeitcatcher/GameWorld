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
    private var descriptioLabel = UILabel()
    
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
        
        setupDescriptioLabel()
    }
    
    private func setupDescriptioLabel() {
        descriptioLabel.font = .systemFont(ofSize: 20)
        descriptioLabel.numberOfLines = 20
        descriptioLabel.text =
            """
            Title: \(game.name)
            Release date: \(game.released)
            """
        descriptioLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionScrollView.addSubview(descriptioLabel)
        
        NSLayoutConstraint.activate([
            descriptioLabel.topAnchor.constraint(equalTo: descriptionScrollView.topAnchor, constant: 10),
            descriptioLabel.leadingAnchor.constraint(equalTo: descriptionScrollView.leadingAnchor, constant: 8),
            descriptioLabel.trailingAnchor.constraint(equalTo: descriptionScrollView.trailingAnchor, constant: -8),
            descriptioLabel.bottomAnchor.constraint(equalTo: descriptionScrollView.bottomAnchor, constant: 16)
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
