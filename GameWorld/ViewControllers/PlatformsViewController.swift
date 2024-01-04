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

enum PlatformsScreenEvent {
    case didTapPlatform(Platform)
}

final class PlatformsViewController: UIViewController {
    
    private let desktops: Set<String> = ["PC", "macOS", "Linux", "Classic Macintosh", "Apple II", "Commodore / Amiga"]
    private let mobile: Set<String> = ["iOS", "Android"]
        
    private var platformsCollectionView: UICollectionView!
    
    private var headerLabel = UILabel()
    
    private lazy var allFilterButton = createFilterButton(title: "All", type: .all)
    private lazy var desktopFilterButton = createFilterButton(title: "Desktop", type: .pc)
    private lazy var consoleFilterButton = createFilterButton(title: "Mobile", type: .mobile)
    private lazy var mobileFilterButton = createFilterButton(title: "Console", type: .console)
    
    private var buttonStackView: UIStackView!
    
    private var filteredPlatforms: Set<Platform> = []
    private var selectedPlatforms: [Platform] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchGames()
    }
    
    private let service: Service
    private let eventHandler: (PlatformsScreenEvent) -> Void
    
    init(service: Service, eventHandler: @escaping (PlatformsScreenEvent) -> Void) {
        self.service = service
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("should never happen")
        return nil
    }
    
    deinit {
        print("deinit \(String(describing: self))")
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        setupPlatformsCollectionView()
        setupButtonStack()
        setupHeaderLabel()
        
        view.backgroundColor = .white
    }
    
    private func fetchGames() {
        print("Starting fetching games in PlatformVC")
        service.fetchPlatforms { [weak self] result in
            switch result {
            case .success(let platforms):
                print("Games fetched succesfully")
                self?.selectedPlatforms = platforms.sorted { $0.name < $1.name }
                self?.platformsCollectionView.reloadData()
            case .failure(let error):
                print("Error after Games fetch: \(error)")
            }
        }
    }
    
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
            platformsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            platformsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            platformsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55)
        ])
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
    
    final class RotatedTitleButton: UIControl {
        let label = UILabel()
        
        init(title: String) {
            super.init(frame: .zero)
            label.text = title
//            label.transform = CGAffineTransform(rotationAngle: .pi / -2)
            clipsToBounds = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
//            label
        }
    }
    
    @objc private func filterPlatforms(_ sender: UIButton) {
        guard let type = PlatformType(rawValue: sender.tag) else { return }
        let platforms = filteredPlatforms.sorted { $0.name < $1.name }
        
        switch type {
        case .all:
            selectedPlatforms = platforms
        case .pc:
            selectedPlatforms = platforms.filter { desktops.contains($0.name) }
        case .console:
            selectedPlatforms = platforms.filter { !mobile.contains($0.name) && !desktops.contains($0.name) }
        case .mobile:
            selectedPlatforms = platforms.filter { mobile.contains($0.name) }
        }
                
        platformsCollectionView.reloadData()
        
        if !filteredPlatforms.isEmpty {
            let indexPath = IndexPath(item: 0, section: 0)
            platformsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    private func setupHeaderLabel() {
        headerLabel.text = "Explore the Games"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 48)
        headerLabel.numberOfLines = 2
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: platformsCollectionView.topAnchor, constant: -32),
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
        return CGSize(width: collectionView.bounds.size.width - 48, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}

//MARK: - UICollectionViewDelegate
extension PlatformsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventHandler(.didTapPlatform(selectedPlatforms[indexPath.item]))
//        print("Navigation Controller: \(String(describing: navigationController))")
    }
}
