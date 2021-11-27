//
//  StarshipListRouter.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import UIKit

class StarshipListRouter {
    
    weak var viewController: StarshipListViewController?
    
    required init(viewController: StarshipListViewController) {
        self.viewController = viewController
    }
                
}
