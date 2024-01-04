//
//  AppDelegate.swift
//  GameWorld
//
//  Created by Arseniy Oksenoyt on 11/4/23.
//

import UIKit

final class Locator {
    let networkManager: NetworkManager = NetworkManagerImpl()
    lazy var service: Service = ServiceImpl(networkManager: networkManager)
}

final class Coordinator {
    let locator: Locator
    let window: UIWindow
    lazy var navigationController = UINavigationController()
    
    init(locator: Locator, window: UIWindow) {
        self.locator = locator
        self.window = window
    }
    
    func startFlow() {
        let platformViewController = PlatformsViewController(service: locator.service) { [locator, navigationController] platformsScreenEvent in
            switch platformsScreenEvent {
            case .didTapPlatform(let platform):
                let gamesVC = GamesByPlatformViewController(service: locator.service, platform: platform)
                navigationController.pushViewController(gamesVC, animated: true)
            }
        }
        
        navigationController.setViewControllers([platformViewController], animated: false)
        
        window.rootViewController = navigationController
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var locator = Locator()
    var coordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.makeKeyAndVisible()
    
        coordinator = Coordinator(locator: locator, window: window!)
        coordinator?.startFlow()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

