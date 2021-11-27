//
//  StarshipListViewController.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import UIKit
import TinyConstraints
import os
import SVProgressHUD

class StarshipListViewController: UIViewController {
    
    // MARK: - Model, view, presenter
    
    var presenter: StarshipListPresenter!
    var configurator: StarshipListConfigurator!
    
    // MARK: - Properties

    
    // MARK: - Constants

    private enum Color {
        static let background: UIColor = .systemBackground
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(viewController: self)
        setup()
        presenter.viewDidLoad()
    }
            
    // MARK: - Setup
    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        // Root view initialisation
        view.backgroundColor = Color.background
    }
    
    private func setupConstraints() {

    }
    
    // MARK: - Private functions
            
}

// MARK: - StarshipListView

extension StarshipListViewController: StarshipListView {
    
    func refresh() {
        // TODO: update to Swift 5.5
        DispatchQueue.main.async {

        }
    }

}

