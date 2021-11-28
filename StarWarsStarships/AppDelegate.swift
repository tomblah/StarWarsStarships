//
//  AppDelegate.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup new window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Set up first view
        let navigationController = UINavigationController()
        let starshipListViewController = StarshipListViewController()
        starshipListViewController.configurator = StarshipListConfigurator()
        navigationController.viewControllers = [ starshipListViewController ]
        window?.rootViewController = navigationController
        
        return true
    }

}

