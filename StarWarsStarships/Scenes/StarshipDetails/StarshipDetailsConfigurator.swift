//
//  StarshipDetailsConfigurator.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 28/11/21.
//

class StarshipDetailsConfigurator {
    
    private let starship: Starship
    
    init(starship: Starship) {
        self.starship = starship
    }
    
    func configure(viewController: StarshipDetailsViewController) {
        let router = StarshipDetailsRouter(viewController: viewController)
        let presenter = StarshipDetailsPresenter(router: router, view: viewController, starship: starship)
        viewController.presenter = presenter
    }
    
}
