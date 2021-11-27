//
//  StarshipListPresenter.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import Foundation
import UIKit
import os

protocol StarshipListView: AnyObject {
    func refresh()
}

class StarshipListPresenter {
    
    // MARK: - Model, view, presenter
    
    private let router: StarshipListRouter
    private weak var view: StarshipListView?
    
    // MARK: - Properties
    
    private var starships: [Starship]?
    private(set) var errorLoading = false
    var loading: Bool { starships == nil && !errorLoading }    
    
    // MARK: - Life-cycle
    
    required init(router: StarshipListRouter, view: StarshipListView?) {
        self.router = router
        self.view = view
    }
    
    func viewDidLoad() {
        // Load the starships
        self.view?.refresh()
        APIClient.sharedInstance.getStarships { [weak self] (starships, _, error) in
            guard let self = self else { return }
            
            // Store the result
            self.starships = starships
            
            // Check for errors, and if so flag error state
            if error != nil { self.errorLoading = true }
                
            // Refresh the view
            self.view?.refresh()
        }
    }
    
    // MARK: - Public functions
    
                
    // MARK: - Private functions
    
}

