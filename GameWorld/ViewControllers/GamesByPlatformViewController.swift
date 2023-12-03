//
//  GamesByPlatformViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/30/23.
//

import UIKit

final class GamesByPlatformViewController: UIViewController {

    private var gamesCollectionView: UICollectionView!
    
    private var selectedGames: [Game]!
    private var selectedPlatform: String!
    
    let platformsVC = PlatformViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        platformsVC.delegate = self
    }
    
    //MARK: - Private methods
    private func setupGamesCollectionView() {
        gamesCollectionView.register(GamesCollectionViewCell.self, forCellWithReuseIdentifier: "gameCell")
        
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        
        view.addSubview(gamesCollectionView)
        
        setupGamesCollectionViewConstraints()
    }
    
    private func setupGamesCollectionViewConstraints() {
        gamesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gamesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -96),
            gamesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gamesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            gamesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])
    }
    
    private func fetchGames() {
        NetworkManager.shared.fetchGames { [ weak self] result in
            switch result {
            case .success(let selectedGames):
                print("Games fetched succesfully")
                self?.selectedGames = selectedGames.games
                self?.gamesCollectionView.reloadData()
            case .failure(let error):
                print("Error after Platforms fetch")
                print(error)
            }
        }
    }
}

//MARK: - Extension
extension GamesByPlatformViewController: PlatformViewControllerDelegate {
    func didSelectPlatform(with name: String, and games: [Game]) {
        selectedGames = games
        selectedPlatform = name
    }
}

//MARK: - UICollectionViewDataSource
extension GamesByPlatformViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "gameCell",
                for: indexPath
            ) as? GamesCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: selectedGames[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegetaFlowLayout
extension GamesByPlatformViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 48, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
