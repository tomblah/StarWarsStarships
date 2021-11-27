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
    
}

enum StarshipListStatus: String {
    case loading = "Loading Starships..."
    case noStarships = "No Starships :'("
    case error = "Error loading starships. Please contact support."
}

class StarshipListPresenter {
    
    // MARK: - Model, view, presenter
    
    private let router: StarshipListRouter
    private weak var view: StarshipListView?
    
    // MARK: - Properties
    

    // MARK: - Life-cycle
    
    required init(router: StarshipListRouter, view: StarshipListView?) {
        self.router = router
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    // MARK: - Public functions
    
                
    // MARK: - Private functions
    
}

