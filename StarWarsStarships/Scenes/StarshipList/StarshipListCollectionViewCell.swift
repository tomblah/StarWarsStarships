//
//  StarshipListCollectionViewCell.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import UIKit

protocol StarshipListCollectionViewCellDelegate: AnyObject {
    func didToggleFavourite(_ starship: Starship)
}

class StarshipListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseId = "StarshipListCollectionViewCell"
    
    private var starship: Starship!
    
    weak var delegate: StarshipListCollectionViewCellDelegate?
    
    private var mainStackView: UIStackView!
    
    // Top line stack view will have the name label and favourite button
    private var topLineStackView: UIStackView!
    private var nameLabel: UILabel!
    private var toggleFavouriteButton: UIButton!

    private var manufacturerLabel: UILabel!
    private var costLabel: UILabel!
    
    // MARK: - Constants

    private enum Font {
        static let nameLabel = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        static let costLabel = UIFont.systemFont(ofSize: 12.0)
        static let manufacturerLabel = UIFont.systemFont(ofSize: 12.0)
    }
    
    private enum Color {
        static let nameLabel: UIColor = .label
        static let costLabel: UIColor = .secondaryLabel
        static let manufacturerLabel: UIColor = .secondaryLabel
    }
    
    private enum AssetName {
        static let toggleFavouriteButton = "star"
        static let toggleFavouriteButtonSelected = "star-selected"
    }
    
    private enum Spacing {
        // TODO: improve these, currently they're not going to win any design awards!
        static let contentHorizontalMargins: CGFloat = 20.0
        static let contentVerticalPadding: CGFloat = 15.0
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
        setupInteraction()
    }
    
    private func setupView() {
        // Main stack view
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        contentView.addSubview(mainStackView)
        
        // Top line stack view
        topLineStackView = UIStackView()
        topLineStackView.axis = .horizontal
        mainStackView.addArrangedSubview(topLineStackView)

        // Name label
        // TODO: ensure no overrun with favourite button
        nameLabel = UILabel()
        nameLabel.font = Font.nameLabel
        nameLabel.textColor = Color.nameLabel
        topLineStackView.addArrangedSubview(nameLabel)

        // Favourite button
        toggleFavouriteButton = UIButton()
        topLineStackView.addArrangedSubview(toggleFavouriteButton)
        
        // Manufacturer label
        manufacturerLabel = UILabel()
        // TODO: consider excessively long manufacturer name
        manufacturerLabel.numberOfLines = 0
        manufacturerLabel.font = Font.manufacturerLabel
        manufacturerLabel.textColor = Color.manufacturerLabel
        mainStackView.addArrangedSubview(manufacturerLabel)
        
        // Cost label
        costLabel = UILabel()
        costLabel.font = Font.costLabel
        costLabel.textColor = Color.costLabel
        mainStackView.addArrangedSubview(costLabel)
    }
    
    private func setupConstraints() {
        // Just set the main stack view's constraints and the stack view's themselves will sort everything out
        mainStackView.edgesToSuperview(insets: .init(top: Spacing.contentVerticalPadding, left: Spacing.contentHorizontalMargins, bottom: Spacing.contentVerticalPadding, right: Spacing.contentHorizontalMargins))
        
        // TODO: maybe padding for favourite button to make it easier to tap
    }
    
    private func setupInteraction() {
        // Toggling the favourite button
        toggleFavouriteButton.addTarget(self, action: #selector(toggleFavouriteButtonPressed), for: .touchUpInside)
    }

    // MARK: - Public functions
    
    func configure(_ starship: Starship, favourited: Bool) {
        // Labels
        nameLabel.text = starship.name
        if let costInCredits = starship.costInCredits {
            costLabel.text = "Cost: \(costInCredits)"
        } else {
            costLabel.text = "Cost unknown - contact manufacturer"
        }
        manufacturerLabel.text = starship.manufacturer
        
        // Favourite button
        toggleFavouriteButton.setImage(UIImage(named: favourited ? AssetName.toggleFavouriteButtonSelected : AssetName.toggleFavouriteButton), for: .normal)
        
        // Keep reference to the starship so we can favourite it
        self.starship = starship
    }
    
    // MARK: - Handlers
    
    @objc private func toggleFavouriteButtonPressed() {
        delegate?.didToggleFavourite(starship)
    }
    
}
