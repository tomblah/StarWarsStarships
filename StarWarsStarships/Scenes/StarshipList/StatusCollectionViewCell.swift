//
//  StatusCollectionViewCell.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import UIKit

class StatusCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseId = "StatusCollectionViewCell"
    
    private var statusLabel: UILabel!
        
    // MARK: - Constants
    
    private enum Font {
        static let statusLabel = UIFont.systemFont(ofSize: 14.0)
    }
    
    private enum Color {
        static let statusLabel: UIColor = .secondaryLabel
    }
    
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
        statusLabel = UILabel()
        statusLabel.font = Font.statusLabel
        statusLabel.textColor = Color.statusLabel
        contentView.addSubview(statusLabel)
    }
    
    private func setupConstraints() {
        statusLabel.centerInSuperview()
    }

    // MARK: - Public functions
    
    func display(_ status: StarshipListStatus) {
        statusLabel.text = status.rawValue
    }

}
