//
//  PlatformCollectionViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/4/23.
//

import UIKit

enum PlatformType: Int {
    case pc = 0
    case console = 1
    case mobile = 2
}

final class PlatformViewController: UIViewController {
    
    private var platformsCollectionView: UICollectionView!
    
    private var desktopFilterButton: UIButton!
    private var consoleFilterButton: UIButton!
    private var mobileFilterButton: UIButton!
    
    private var buttonStackView: UIStackView!
    
    private let desktops: Set<String> = ["PC", "macOS", "Linux", "Classic Macintosh", "Apple II", "Commodore / Amiga"]
    private let mobile: Set<String> = ["iOS", "Android"]
    
    private var platforms: [Platform] = []
    private var filteredPlatforms: [Platform] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPlatforms()
        setupCollectionView()
        setupFilterButtons()
        
        view.backgroundColor = .white
    }
    
    //MARK: - Private Methods
    private func fetchPlatforms() {
        NetworkManager.shared.fetchPlatforms { [ weak self ] result in
            switch result {
            case .success(let platformsCollection):
                print("Platforms fetched succesfully")
                self?.platforms = platformsCollection.platforms
                self?.filteredPlatforms = platformsCollection.platforms
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
    
    private func setupFilterButtons() {
        desktopFilterButton = createFilterButton(title: "All", type: .pc)
        mobileFilterButton = createFilterButton(title: "Mobile", type: .mobile)
        consoleFilterButton = createFilterButton(title: "Console", type: .console)
        
        setupButtonStack()
    }
    
    private func setupButtonStack() {
        buttonStackView = UIStackView(arrangedSubviews: [desktopFilterButton, consoleFilterButton, mobileFilterButton])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 20
        view.addSubview(buttonStackView)
        
        setupButtonStackViewConstraints()
    }
    
    private func setupButtonStackViewConstraints() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -96),
            buttonStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
            buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13)
        ])
    }
    
    private func createFilterButton(title: String, type: PlatformType) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(filterPlatforms(_:)), for: .touchUpInside)
        button.tag = type.rawValue
        //        button.transform = CGAffineTransform(rotationAngle: .pi / -2)
        return button
    }
    
    @objc private func filterPlatforms(_ sender: UIButton) {
        guard let type = PlatformType(rawValue: sender.tag) else { return }
        
        switch type {
        case .pc:
            filteredPlatforms = platforms
        case .console:
            filteredPlatforms = platforms.filter { mobile.contains($0.name) }
        case .mobile:
            filteredPlatforms = platforms.filter { !mobile.contains($0.name) && !desktops.contains($0.name)}
        }
        
        platformsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension PlatformViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredPlatforms.count
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
        cell.configure(with: filteredPlatforms[indexPath.item])
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
