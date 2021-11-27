//
//  StarshipListCollectionViewCell.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import UIKit

class StarshipListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseId = "StarshipListCollectionViewCell"
        
    // MARK: - Constants

    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
        
    // MARK: - Setup
    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        
    }
    
    private func setupConstraints() {
        
    }

    // MARK: - Public functions
    
    func configure(_ starship: Starship) {
        
    }
    
}
