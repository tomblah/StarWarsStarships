//
//  StarshipDetailsRouter.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 28/11/21.
//

import UIKit

class StarshipDetailsRouter {
    
    weak var viewController: StarshipDetailsViewController?
    
    required init(viewController: StarshipDetailsViewController) {
        self.viewController = viewController
    }
                
}
