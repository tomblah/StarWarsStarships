//
//  StarshipDetailsPresenter.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 28/11/21.
//

import Foundation
import UIKit
import os

protocol StarshipDetailsView: AnyObject {
    func refresh()
}

class StarshipDetailsPresenter {
    
    // MARK: - Model, view, presenter
    
    private let router: StarshipDetailsRouter
    private weak var view: StarshipDetailsView?
    
    // MARK: - Properties
    
    let starship: Starship
    
    var favourited: Bool { AppManager.sharedInstance.favouritedStarships.contains(starship) }
    
    // MARK: - Life-cycle
    
    required init(router: StarshipDetailsRouter, view: StarshipDetailsView?, starship: Starship) {
        self.router = router
        self.view = view
        self.starship = starship
    }
    
    // MARK: - Public functions

    func toggleFavouriteButtonPressed() {
        // TODO: refactor, probably want a class that handles the favouriting rather than copying and pasting this code!
        // Remove if already favourited
        if AppManager.sharedInstance.favouritedStarships.contains(starship) {
            AppManager.sharedInstance.favouritedStarships.removeAll { $0 == starship }
        } else {
            AppManager.sharedInstance.favouritedStarships.append(starship)
        }
        
        // Refresh view
        self.view?.refresh()
    }

}

