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

import ActionSheetPicker_3_0

class StarshipListViewController: UIViewController {
    
    // MARK: - Model, view, presenter
    
    var presenter: StarshipListPresenter!
    var configurator: StarshipListConfigurator!
    
    // MARK: - Properties

    private var collectionView: UICollectionView!
    private var cellWidth: CGFloat { collectionView!.bounds.width }
    private var cellHeight: CGFloat { Size.cellHeight }
    private var cellSize: CGSize { CGSize(width: cellWidth, height: cellHeight) }
    
    // MARK: - Constants

    private enum Size {
        static let cellHeight: CGFloat = 105.0
    }
    
    private enum Color {
        static let background: UIColor = .systemBackground
    }
    
    private enum Text {
        static let navigationTitle = "Starships"
        
        static let loading = "Loading starships..."
        static let error = "Error loading starships"
        static let noResults = "No starship available"
        
        static let sortActionSheetStringPickerTitle = "Sort Starships By"
    }
    
    private enum AssetName {
        static let sortBarButtonItem = "sort"
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
        navigationItem.title = Text.navigationTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: AssetName.sortBarButtonItem), style: .plain, target: self, action: #selector(self.sortBarButtonItemPressed))
        
        // Collection view flow layout
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        
        // Collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StarshipListCollectionViewCell.self, forCellWithReuseIdentifier: StarshipListCollectionViewCell.reuseId)
        collectionView.register(StatusCollectionViewCell.self, forCellWithReuseIdentifier: StatusCollectionViewCell.reuseId)
        
        // Disable horizontal scroll bars as they visually interfere with scrolling
        collectionView.showsHorizontalScrollIndicator = false
        
        // TODO: separator lines (and/or alternating background shadings for cells)
        
        // TODO: pull to refresh via refresh control
        
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        // Simply pin the collection view to the edges of the view
        collectionView.edgesToSuperview(usingSafeArea: true)
    }
    
    // MARK: - Handlers
    
    @objc private func sortBarButtonItemPressed() {
        // Show sort options in action sheet
        ActionSheetStringPicker(title: Text.sortActionSheetStringPickerTitle, rows: presenter.sortFieldTitles, initialSelection: presenter.selectedSortFieldIndex, doneBlock: { picker, index, selectedModuleFileTitle in
            
            self.presenter.didSelectSortField(atIndex: index)
            
        }, cancel: nil, origin: self.view).show()
    }
            
}

// MARK: - StarshipListView

extension StarshipListViewController: StarshipListView {
        
    func refresh() {
        // TODO: update to Swift 5.5
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension StarshipListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
}

// MARK: - UICollectionViewDataSource

extension StarshipListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If we don't have results to show, we need one cell to show the status (loading, error, no results)
        guard let numberOfStarships = presenter.numberOfStarships, numberOfStarships > 0 else { return 1 }
        return numberOfStarships
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Loading cell
        if presenter.loading {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCollectionViewCell.reuseId, for: indexPath) as! StatusCollectionViewCell
            cell.display(Text.loading)
            return cell
        }
        
        // Error loading cell
        if presenter.errorLoading {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCollectionViewCell.reuseId, for: indexPath) as! StatusCollectionViewCell
            cell.display(Text.error)
            return cell
        }
        
        // No results cell
        if !presenter.hasResultsToShow {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCollectionViewCell.reuseId, for: indexPath) as! StatusCollectionViewCell
            cell.display(Text.noResults)
            return cell
        }
        
        // Get cell and configure with the starship object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StarshipListCollectionViewCell.reuseId, for: indexPath) as! StarshipListCollectionViewCell
        
        guard let starship = presenter.starship(atIndex: indexPath.item) else { return cell }
        
        cell.configure(starship, favourited: presenter.isFavourited(starship))
        
        // Delegate so we can support favouriting
        cell.delegate = self
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension StarshipListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(atIndex: indexPath.item)
    }
        
}

// MARK: - StarshipListCollectionViewCellDelegate

extension StarshipListViewController: StarshipListCollectionViewCellDelegate {
    
    func didToggleFavourite(_ starship: Starship) {
        presenter.didToggleFavourte(starship)
    }
        
}

