//
//  GamesByPlatformViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/30/23.
//

import UIKit

final class GamesByPlatformViewController: UIViewController {
    
    private var gamesCollectionView: UICollectionView!
    private var selectedPlatformLabel = UILabel()
    private var sortingButton = UIButton()
    
    private var allGames: [Game] = []
    
    let service: Service
    let platform: Platform
    
    init(service: Service, platform: Platform) {
        self.service = service
        self.platform = platform
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit \(String(describing: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupGamesCollectionView()
        setupSelectedPlatformLabel()
        setupSortingButton()
        
        service.fetchGames(platform: platform) { [weak self] result in
            switch result {
            case .success(let games):
                self?.allGames = games
                self?.gamesCollectionView.reloadData()
            case .failure(let error):
                self?.allGames = []
            }
        }
    }
    
    //MARK: - Private Methods
    private func setupGamesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        gamesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gamesCollectionView.register(GamesCollectionViewCell.self, forCellWithReuseIdentifier: "gameCell")
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        gamesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(gamesCollectionView)
        NSLayoutConstraint.activate([
            gamesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 256),
            gamesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -96),
            gamesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            gamesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupSelectedPlatformLabel() {
        selectedPlatformLabel.text = platform.name
        selectedPlatformLabel.font = UIFont.boldSystemFont(ofSize: 32)
        selectedPlatformLabel.backgroundColor = .green
        selectedPlatformLabel.numberOfLines = 2
        selectedPlatformLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(selectedPlatformLabel)
        NSLayoutConstraint.activate([
            selectedPlatformLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            selectedPlatformLabel.bottomAnchor.constraint(equalTo: gamesCollectionView.topAnchor, constant: -32),
            selectedPlatformLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            selectedPlatformLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10)
        ])
    }
    
    private func setupSortingButton() {
        sortingButton.setTitle("Sort the list", for: .normal)
        sortingButton.backgroundColor = .gray
        sortingButton.titleLabel?.numberOfLines = 2
        sortingButton.addTarget(self, action: #selector(sortGames(_:)), for: .touchUpInside)
        sortingButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sortingButton)
        NSLayoutConstraint.activate([
            sortingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            sortingButton.bottomAnchor.constraint(equalTo: gamesCollectionView.topAnchor, constant: -32),
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
        detailsVC.game = allGames[indexPath.item]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
