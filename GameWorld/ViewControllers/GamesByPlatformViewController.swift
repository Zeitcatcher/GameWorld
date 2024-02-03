//
//  GamesByPlatformViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/30/23.
//

import UIKit

final class GamesByPlatformViewController: UIViewController {
    private let networkManager: NetworkManager = NetworkManagerImpl()
    
    private lazy var gamesCollectionView: UICollectionView = createGamesCollectionView()
    private var selectedPlatformLabel = UILabel()
    private var sortingButton = UIButton()
    
    private var allGames: [Game] = []
    var selectedPlatform: Platform
    
    init(selectedPlatform: Platform) {
        self.selectedPlatform = selectedPlatform
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)

        fetchGames()
        setupSelectedPlatformLabel()
        setupSortingButton()
        setupGamesCollectionView()
    }
    
    //MARK: - Private Methods
    private func fetchGames() {
        networkManager.fetchGames(platform: selectedPlatform) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let games):
                self.allGames = games.sorted { $0.name > $1.name }
                self.gamesCollectionView.reloadData()
            case .failure(let error):
                print("Error after Games fetch: \(error)")
            }
        }
    }
    
    private func createGamesCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(GamesCollectionViewCell.self, forCellWithReuseIdentifier: "gameCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
    
    private func setupGamesCollectionView() {
        view.addSubview(gamesCollectionView)
        
        NSLayoutConstraint.activate([
            gamesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            gamesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gamesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            gamesCollectionView.topAnchor.constraint(equalTo: selectedPlatformLabel.bottomAnchor, constant: 32)
        ])
    }
    
    private func setupSelectedPlatformLabel() {
        selectedPlatformLabel.text = selectedPlatform.name
        selectedPlatformLabel.font = UIFont.boldSystemFont(ofSize: 32)
        selectedPlatformLabel.textColor = .white
        selectedPlatformLabel.numberOfLines = 2
        selectedPlatformLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(selectedPlatformLabel)
        
        NSLayoutConstraint.activate([
            selectedPlatformLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectedPlatformLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedPlatformLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            selectedPlatformLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func setupSortingButton() {
        sortingButton.setTitle("Sort the list", for: .normal)
        sortingButton.backgroundColor = UIColor.clear
        sortingButton.setTitleColor(#colorLiteral(red: 1, green: 0.6176686287, blue: 0.2882549167, alpha: 1), for: .normal)
        sortingButton.titleLabel?.numberOfLines = 2
        sortingButton.addTarget(self, action: #selector(sortGames(_:)), for: .touchUpInside)
        sortingButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sortingButton)
        
        NSLayoutConstraint.activate([
            sortingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            sortingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            sortingButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            sortingButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    @objc private func sortGames(_ sender: UIButton) {
        let isAscending = sortingButton.title(for: .normal) == "Sort By: ↓"
        allGames.sort { isAscending ? $0.name > $1.name : $0.name < $1.name }
        sortingButton.setTitle(isAscending ? "Sort By: ↑" : "Sort By: ↓", for: .normal)
        gamesCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension GamesByPlatformViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GamesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: allGames[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GamesByPlatformViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.size.width / 2 - 16, height: collectionView.bounds.size.height / 2 - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

// MARK: - UICollectionViewDelegate
extension GamesByPlatformViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = GameDetailsViewController()
        detailsVC.tappedGameName = allGames[indexPath.item].name
        detailsVC.tappedGameID = allGames[indexPath.item].id
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
