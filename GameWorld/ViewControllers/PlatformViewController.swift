//
//  PlatformCollectionViewController.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/4/23.
//

import UIKit

enum PlatformType: Int {
    case all = 0
    case pc = 1
    case console = 2
    case mobile = 3
}

final class PlatformViewController: UIViewController {
    
    private let desktops: Set<String> = ["PC", "macOS", "Linux", "Classic Macintosh", "Apple II", "Commodore / Amiga"]
    private let mobile: Set<String> = ["iOS", "Android"]
        
    private var platformsCollectionView: UICollectionView!
    
    private var headerLabel: UILabel!
    
    private var allFilterButton: UIButton!
    private var desktopFilterButton: UIButton!
    private var consoleFilterButton: UIButton!
    private var mobileFilterButton: UIButton!
    
    private var buttonStackView: UIStackView!
    
//    private var platforms: [Platform] = []
    private var games: [Game] = []
    private var filteredPlatforms: Set<Platform> = []
    private var selectedPlatforms: [Platform] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Private Methods
    private func setupUI() {
//        fetchPlatforms()
        fetchGames()
        setupPlatformsCollectionView()
        setupFilterButtons()
        setupHeaderLabel()
        
        view.backgroundColor = .white
    }
    
    private func fetchGames() {
        print("Starting fetching games in PlatformVC")
        NetworkManager.shared.fetchGames { [ weak self ] result in
            switch result {
            case .success(let gamesCollection):
                print("Games fetched succesfully")
                self?.games = gamesCollection.games
                self?.filterPlatrorms()
                self?.platformsCollectionView.reloadData()
            case .failure(let error):
                print("Error after Games fetch")
                print(error)
            }
        }
    }
    
//    private func fetchPlatforms() {
//        NetworkManager.shared.fetchPlatforms { [ weak self ] result in
//            switch result {
//            case .success(let platformsCollection):
//                print("Platforms fetched succesfully")
//                self?.platforms = platformsCollection.platforms
//                self?.filteredPlatforms = platformsCollection.platforms
//                self?.platformsCollectionView.reloadData()
//            case .failure(let error):
//                print("Error after Platforms fetch")
//                print(error)
//            }
//        }
//    }
    
    private func setupPlatformsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        platformsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        platformsCollectionView.register(PlatformsCollectionViewCell.self, forCellWithReuseIdentifier: "platformCell")
        platformsCollectionView.delegate = self
        platformsCollectionView.dataSource = self
        
        view.addSubview(platformsCollectionView)
        
        setupPlatformsCollectionViewConstraints()
    }
    
    private func setupPlatformsCollectionViewConstraints() {
        platformsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            platformsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -96),
            platformsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            platformsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            platformsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])
    }
    
    private func setupFilterButtons() {
        allFilterButton = createFilterButton(title: "All", type: .all)
        desktopFilterButton = createFilterButton(title: "Desktop", type: .pc)
        mobileFilterButton = createFilterButton(title: "Mobile", type: .mobile)
        consoleFilterButton = createFilterButton(title: "Console", type: .console)
        
        setupButtonStack()
    }
    
    private func setupButtonStack() {
        buttonStackView = UIStackView(
            arrangedSubviews: [
                allFilterButton,
                desktopFilterButton,
                consoleFilterButton,
                mobileFilterButton
            ]
        )
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
        case .all:
            selectedPlatforms = filteredPlatforms.sorted { $0.name < $1.name }
        case .pc:
            let platforms = filteredPlatforms.sorted { $0.name < $1.name }
            selectedPlatforms = platforms.filter { desktops.contains($0.name) }
        case .console:
            let platforms = filteredPlatforms.sorted { $0.name < $1.name }
            selectedPlatforms = platforms.filter { !mobile.contains($0.name) && !desktops.contains($0.name) }
        case .mobile:
            let platforms = filteredPlatforms.sorted { $0.name < $1.name }
            selectedPlatforms = platforms.filter { mobile.contains($0.name) }
        }
        
        platformsCollectionView.reloadData()
        
        if !filteredPlatforms.isEmpty {
            let indexPath = IndexPath(item: 0, section: 0)
            platformsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    private func filterPlatrorms() {
        games.forEach { game in
            game.platforms?.forEach({ platform in
                filteredPlatforms.insert(platform.platform)
            })
        }
        selectedPlatforms = filteredPlatforms.sorted { $0.name < $1.name }
    }
    
    private func setupHeaderLabel() {
        headerLabel = UILabel()
        headerLabel.text = "Explore the Games"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 48)
        headerLabel.numberOfLines = 2
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            headerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            headerLabel.heightAnchor.constraint(equalToConstant: 128)
        ])
    }
}



// MARK: - UICollectionViewDataSource
extension PlatformViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedPlatforms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "platformCell",
                for: indexPath
            ) as? PlatformsCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: selectedPlatforms[indexPath.item])
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

//MARK: - UICollectionViewDelegate
extension PlatformViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Navigation Controller: \(String(describing: navigationController))")
        let gamesVC = GamesByPlatformViewController()
        gamesVC.allGames = games
        gamesVC.selectedPlatform = selectedPlatforms[indexPath.item].name
        print("didSelectPlatform on PlatformsVC performed")
        

        // Debugging: Print the navigation controller
        if let navController = navigationController {
            print("Pushing GamesByPlatformViewController onto the navigation stack")
            navController.pushViewController(gamesVC, animated: true)
        } else {
            print("Navigation controller not found")
        }
    }
}
