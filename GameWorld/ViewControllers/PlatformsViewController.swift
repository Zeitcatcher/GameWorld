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

final class PlatformsViewController: UIViewController {
    
    private let networkManager: NetworkManager = NetworkManagerImpl()
    
    private let desktops: Set<String> = ["PC", "macOS", "Linux", "Classic Macintosh", "Apple II", "Commodore / Amiga"]
    private let mobile: Set<String> = ["iOS", "Android"]
        
    private var platformsCollectionView: UICollectionView!
    
    private var headerLabel = UILabel()
    
    private var allFilterButton: UIButton!
    private var desktopFilterButton: UIButton!
    private var consoleFilterButton: UIButton!
    private var mobileFilterButton: UIButton!
    
    private var buttonStackView: UIStackView!
    
    private var games: [Game] = []
    private var platforms: [Platform] = []
    private var selectedPlatforms: [Platform] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        fetchPlatforms()
        setupHeaderLabel()
        setupFilterButtons()
        setupPlatformsCollectionView()
        
        view.backgroundColor = #colorLiteral(red: 0.06452215463, green: 0.215518266, blue: 0.319472909, alpha: 1)
    }
    
    private func fetchPlatforms() {
        print("Starting fetching Platforms in PlatformVC")
        networkManager.fetchPlatforms { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let platforms):
                print("Platforms fetched succesfully")
                self.platforms = platforms.sorted { $0.name < $1.name }
                self.selectedPlatforms = platforms.sorted { $0.name < $1.name }
                self.platformsCollectionView.reloadData()
            case .failure(let error):
                print("Error after Platform fetch: \(error)")
            }
        }
    }
    
    private func setupPlatformsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        platformsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        platformsCollectionView.backgroundColor = UIColor.clear
        platformsCollectionView.register(PlatformsCollectionViewCell.self, forCellWithReuseIdentifier: "platformCell")
        platformsCollectionView.delegate = self
        platformsCollectionView.dataSource = self
        
        view.addSubview(platformsCollectionView)
        
        platformsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            platformsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            platformsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            platformsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            platformsCollectionView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 32)
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
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 20
        view.addSubview(buttonStackView)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 64),
            buttonStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])
    }
    
    private func createFilterButton(title: String, type: PlatformType) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(#colorLiteral(red: 1, green: 0.6176686287, blue: 0.2882549167, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(filterPlatforms(_:)), for: .touchUpInside)
        button.tag = type.rawValue
        return button
    }
    
    @objc private func filterPlatforms(_ sender: UIButton) {
        guard let type = PlatformType(rawValue: sender.tag) else { return }
        let platforms = platforms
        
        switch type {
        case .all:
            selectedPlatforms = platforms
        case .pc:
            print(platforms)
            selectedPlatforms = platforms.filter { desktops.contains($0.name) }
        case .console:
            print(platforms)
            selectedPlatforms = platforms.filter { !mobile.contains($0.name) && !desktops.contains($0.name) }
        case .mobile:
            print(platforms)
            selectedPlatforms = platforms.filter { mobile.contains($0.name) }
            print("---------)")
            print(platforms)
        }
                
        platformsCollectionView.reloadData()
        
        if !platforms.isEmpty {
            let indexPath = IndexPath(item: 0, section: 0)
            platformsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    private func setupHeaderLabel() {
        headerLabel.text = "Explore the Games"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 48)
        headerLabel.numberOfLines = 2
        headerLabel.textColor = .white
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            headerLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension PlatformsViewController: UICollectionViewDataSource {
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
extension PlatformsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width * 0.7, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

//MARK: - UICollectionViewDelegate
extension PlatformsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Navigation Controller: \(String(describing: navigationController))")
        let gamesVC = GamesByPlatformViewController(selectedPlatform: selectedPlatforms[indexPath.item])
        print("During data transfer selectedPlatform is: \(selectedPlatforms[indexPath.item].name)")
//        gamesVC.allGames = games.filter {
//            $0.platforms?.contains(where: {
//                $0.platform.name == selectedPlatforms[indexPath.item].name
//            }) ?? false
//        }
//        gamesVC.allGames.forEach { game in
//            print("transfered games are: \(game.name)")
//        }
//        gamesVC.selectedPlatform = selectedPlatforms[indexPath.item]
//        print("didSelectPlatform on PlatformsVC performed")
        

        // Debugging: Print the navigation controller
        if let navController = navigationController {
            //            print("Pushing GamesByPlatformViewController onto the navigation stack")
            navController.pushViewController(gamesVC, animated: true)
        }
//        } else {
//            print("Navigation controller not found")
//        }
    }
}
