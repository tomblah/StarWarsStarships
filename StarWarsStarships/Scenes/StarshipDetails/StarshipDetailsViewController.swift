//
//  StarshipDetailsViewController.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 28/11/21.
//

import UIKit
import TinyConstraints
import os
import SVProgressHUD

import ActionSheetPicker_3_0

class StarshipDetailsViewController: UIViewController {
    
    // MARK: - Model, view, presenter
    
    var presenter: StarshipDetailsPresenter!
    var configurator: StarshipDetailsConfigurator!
    
    // MARK: - Properties

    // We'll use a similar layout design as the main list, we'll just flesh it out with more properties
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var mainStackView: UIStackView!
    
    // Top line stack view will have the name label and favourite button
    private var topLineStackView: UIStackView!
    private var nameLabel: UILabel!
    private var toggleFavouriteButton: UIButton!

    // Detail labels
    // NB: we've chosen a larger subset of fields to show for this details screen, obviously we could display much more on this screen, but showing absolutely everything here I don't think is the point of this exercise!
    private var manufacturerLabel: UILabel!
    private var modelLengthAndSpeedLabel: UILabel!
    private var capacityCrewAndPassengersLabel: UILabel!
    private var costLabel: UILabel!
    
    // MARK: - Constants
    
    private enum Spacing {
        static let betweenElements: CGFloat = 15.0
        static let contentPadding: CGFloat = 20.0
    }

    private enum Font {
        // NB: keeping things really simple, we'll have a header and a bunch of detail labels
        static let headerLabel = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        static let detailLabel = UIFont.systemFont(ofSize: 12.0)
    }
    
    private enum Color {
        static let background: UIColor = .systemBackground
        static let headerLabel: UIColor = .label
        static let detailLabel: UIColor = .secondaryLabel
    }
    
    private enum AssetName {
        static let toggleFavouriteButton = "star"
        static let toggleFavouriteButtonSelected = "star-selected"
    }
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(viewController: self)
        setup()
    }
            
    // MARK: - Setup
    
    private func setup() {
        setupView()
        setupConstraints()
        setupInteraction()
    }
    
    private func setupView() {
        // Root view initialisation
        view.backgroundColor = Color.background
        navigationItem.title = presenter.starship.name
        
        // Scroll view and its content view
        // NB: technically the content view is superfluous (we can set the equivalent constraints on the main stack view), but I like to have a content view whose job is to purely satisfy the scroll view's constraints
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        // Main stack view
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = Spacing.betweenElements
        contentView.addSubview(mainStackView)
        
        // Top line stack view
        topLineStackView = UIStackView()
        topLineStackView.axis = .horizontal
        mainStackView.addArrangedSubview(topLineStackView)

        // Name label
        // TODO: ensure no overrun with favourite button
        nameLabel = UILabel()
        nameLabel.text = presenter.starship.name
        nameLabel.font = Font.headerLabel
        nameLabel.textColor = Color.headerLabel
        topLineStackView.addArrangedSubview(nameLabel)

        // Favourite button
        toggleFavouriteButton = UIButton()
        setCorrectFavouriteButtonAsset()
        topLineStackView.addArrangedSubview(toggleFavouriteButton)
        
        // Manufacturer label
        manufacturerLabel = UILabel()
        manufacturerLabel.text = presenter.starship.manufacturer
        // TODO: consider excessively long manufacturer name
        manufacturerLabel.numberOfLines = 0
        manufacturerLabel.font = Font.detailLabel
        manufacturerLabel.textColor = Color.detailLabel
        mainStackView.addArrangedSubview(manufacturerLabel)
        
        // Model length and speed label
        modelLengthAndSpeedLabel = UILabel()
        modelLengthAndSpeedLabel.numberOfLines = 0
        // TODO: whoops, refactor: I overlooked that some of the starships don't have atmosphering speeds (my knowledge of Star Wars is not up to scratch!)
        let speedString = Double(presenter.starship.maxAtmospheringSpeed) != nil ? " and boasts a top atmosphering speed of \(presenter.starship.maxAtmospheringSpeed) galactic speed units!" : "."
        modelLengthAndSpeedLabel.text = "This \(presenter.starship.model) class starship has a length of \(presenter.starship.length) galactic feet\(speedString)"
        modelLengthAndSpeedLabel.font = Font.detailLabel
        modelLengthAndSpeedLabel.textColor = Color.detailLabel
        mainStackView.addArrangedSubview(modelLengthAndSpeedLabel)
        
        // Crew, passengers and capacity label
        capacityCrewAndPassengersLabel = UILabel()
        capacityCrewAndPassengersLabel.numberOfLines = 0
        let passengersString: String
        if let passengers = presenter.starship.passengers, passengers > 0 {
            passengersString = " and \(passengers) passengers"
        } else {
            passengersString = ""
        }
        capacityCrewAndPassengersLabel.text = "Seating \(presenter.starship.crew) crew\(passengersString) this starship has enough room leftover for \(presenter.starship.cargoCapacity) galactic gallons of cargo!"
        capacityCrewAndPassengersLabel.font = Font.detailLabel
        capacityCrewAndPassengersLabel.textColor = Color.detailLabel
        mainStackView.addArrangedSubview(capacityCrewAndPassengersLabel)

        // Cost label
        costLabel = UILabel()
        // TODO: maybe factor this out into a convenience property on Starship or something
        if let costInCredits = presenter.starship.costInCredits {
            costLabel.text = "Cost: \(costInCredits)"
        } else {
            costLabel.text = "Cost unknown - contact manufacturer"
        }
        costLabel.font = Font.detailLabel
        costLabel.textColor = Color.detailLabel
        mainStackView.addArrangedSubview(costLabel)        
    }
    
    private func setupConstraints() {
        // Scroll view and contents
        scrollView.edgesToSuperview(usingSafeArea: true)
        contentView.edgesToSuperview()
        // We'll support vertical scrolling, but not horizontal scrolling
        contentView.width(to: self.view)
        
        mainStackView.edgesToSuperview(insets: .uniform(Spacing.contentPadding))
        
        // Ensure favourite button is right aligned
        toggleFavouriteButton.setHugging(.required, for: .horizontal)
    }
    
    private func setupInteraction() {
        // Toggling the favourite button
        toggleFavouriteButton.addTarget(self, action: #selector(toggleFavouriteButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - Handlers
    
    @objc private func toggleFavouriteButtonPressed() {
        presenter.toggleFavouriteButtonPressed()
    }
    
    // MARK: - Private functions
    
    private func setCorrectFavouriteButtonAsset() {
        toggleFavouriteButton.setImage(UIImage(named: presenter.favourited ? AssetName.toggleFavouriteButtonSelected : AssetName.toggleFavouriteButton), for: .normal)
    }
    
}

// MARK: - StarshipListView

extension StarshipDetailsViewController: StarshipDetailsView {
        
    func refresh() {
        // TODO: update to Swift 5.5
        DispatchQueue.main.async {
            self.setCorrectFavouriteButtonAsset()
        }
    }

}

