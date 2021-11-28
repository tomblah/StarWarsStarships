//
//  StarshipListRouter.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import UIKit

class StarshipListRouter {
    
    weak var viewController: StarshipListViewController?
    
    private var navigationController: UINavigationController? { viewController?.navigationController }
    
    required init(viewController: StarshipListViewController) {
        self.viewController = viewController
    }
    
    func presentStarshipDetails(_ starship: Starship) {
        let starshipDetailsViewController = StarshipDetailsViewController()
        starshipDetailsViewController.configurator = StarshipDetailsConfigurator(starship: starship)
        navigationController?.pushViewController(starshipDetailsViewController, animated: true)
    }
    
}
