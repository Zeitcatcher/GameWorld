//
//  PlatformCollectionViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/4/23.
//

import UIKit

final class PlatformCollectionViewController: UIViewController {

    @IBOutlet private weak var platformsCollectionViewController: UICollectionView!
    
    private var platforms: [Platform] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    //MARK: - Private Methods
    private func fetchPhotos() {
        NetworkManager.shared.fetchPlatforms { [ weak self ] result in
            switch result {
            case .success(let platformsCollection):
                print("Platforms fetched succesfully")
                self?.platforms = platformsCollection.platforms
                self?.platformsCollectionViewController.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        platformsCollectionViewController.collectionViewLayout = layout
        platformsCollectionViewController.delegate = self
        platformsCollectionViewController.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension PlatformCollectionViewController:UICollectionViewDataSource {
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
extension PlatformCollectionViewController: UICollectionViewDelegateFlowLayout {
}
