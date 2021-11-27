//
//  StarshipListConfigurator.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

class StarshipListConfigurator {
    
    func configure(viewController: StarshipListViewController) {
        let router = StarshipListRouter(viewController: viewController)
        let presenter = StarshipListPresenter(router: router, view: viewController)
        viewController.presenter = presenter
    }
    
}
