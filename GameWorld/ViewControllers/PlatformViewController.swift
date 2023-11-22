//
//  PlatformCollectionViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/4/23.
//

import UIKit

final class PlatformViewController: UIViewController {

    private var platformsCollectionView: UICollectionView!
    
    private var platforms: [Platform] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPlatforms()
        setupCollectionView()
        view.backgroundColor = .blue
    }
    
    //MARK: - Private Methods
    private func fetchPlatforms() {
        NetworkManager.shared.fetchPlatforms { [ weak self ] result in
            switch result {
            case .success(let platformsCollection):
                print("Platforms fetched succesfully")
                self?.platforms = platformsCollection.platforms
                self?.platformsCollectionView.reloadData()
            case .failure(let error):
                print("Error after Platforms fetch")
                print(error)
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        platformsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        platformsCollectionView.register(PlatformCollectionViewCell.self, forCellWithReuseIdentifier: "platformCell")
        
        platformsCollectionView.delegate = self
        platformsCollectionView.dataSource = self
        
        view.addSubview(platformsCollectionView)
        
        setupCollectionViewConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        platformsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            platformsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -96),
            platformsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            platformsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            platformsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension PlatformViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        platforms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "platformCell",
                for: indexPath
            ) as? PlatformCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: platforms[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegetaFlowLayout
extension PlatformViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 48, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
