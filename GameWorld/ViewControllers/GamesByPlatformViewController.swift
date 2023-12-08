//
//  GamesByPlatformViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/30/23.
//

import UIKit

final class GamesByPlatformViewController: UIViewController {

    private var gamesCollectionView: UICollectionView!
    
    var allGames: [Game] = []
    var selectedPlatform: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGames()
        print("GameVC loaded")
        setupGamesCollectionView()
    }
    
    //MARK: - Private methods
    private func setupGamesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        gamesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gamesCollectionView.register(GamesCollectionViewCell.self, forCellWithReuseIdentifier: "gameCell")
        
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        
        view.addSubview(gamesCollectionView)
        
        setupGamesCollectionViewConstraints()
    }
    
    private func setupGamesCollectionViewConstraints() {
        gamesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gamesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            gamesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -96),
            gamesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gamesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchGames() {
        NetworkManager.shared.fetchGames { [ weak self ] result in
            switch result {
            case .success(let selectedGames):
                print("Games fetched succesfully")
                self?.allGames = selectedGames.games
                self?.gamesCollectionView.reloadData()
            case .failure(let error):
                print("Error with Games fetching")
                print(error)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension GamesByPlatformViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("GameByPlatformVC allGames.count = \(allGames.count)")
        return allGames.count
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
        cell.configure(with: allGames[indexPath.item])
//        print(allGames[indexPath.item])
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
