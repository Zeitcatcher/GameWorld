//
//  GamesByPlatformViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/30/23.
//

import UIKit

final class GamesByPlatformViewController: UIViewController {

    private var gamesCollectionView: UICollectionView!
    private var selectedPlatformLabel: UILabel!
    private var sortingButton: UIButton!
    
    var allGames: [Game] = []
    var selectedPlatform: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        fetchGames()
        print("GameVC loaded")
        setupGamesCollectionView()
        setupSelectedPlatformLabel()
        setupSortingButton()
    }
    
    //MARK: - Private methods
    private func setupSortingButton() {
        sortingButton = UIButton()
        sortingButton.titleLabel?.numberOfLines = 2
        sortingButton.backgroundColor = .gray
        sortingButton.setTitle("Sort By", for: .normal)
        
        sortingButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sortingButton)
        
        NSLayoutConstraint.activate([
            sortingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            sortingButton.bottomAnchor.constraint(equalTo: gamesCollectionView.topAnchor, constant: -32),
            sortingButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            sortingButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
        
    }
    
    private func setupSelectedPlatformLabel() {
        selectedPlatformLabel = UILabel()
        selectedPlatformLabel.text = selectedPlatform
        selectedPlatformLabel.font = UIFont.boldSystemFont(ofSize: 32)
        selectedPlatformLabel.numberOfLines = 2
        selectedPlatformLabel.backgroundColor = .green
        
        selectedPlatformLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(selectedPlatformLabel)
        
        NSLayoutConstraint.activate([
            selectedPlatformLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            selectedPlatformLabel.bottomAnchor.constraint(equalTo: gamesCollectionView.topAnchor, constant: -32),
            selectedPlatformLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            selectedPlatformLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10)
        ])
    }
    
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
            gamesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 256),
            gamesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -96),
            gamesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            gamesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
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
        return cell
    }
}

//MARK: - UICollectionViewDelegetaFlowLayout
extension GamesByPlatformViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / 2 - 16, height: collectionView.bounds.size.height / 2 - 16)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
