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

enum SortField: String, CaseIterable {
    case natural = "None"
    case favourited = "Favourited"
    case name = "Name"
    case edited = "Last updated"
    case cost = "Cost"
    case passengers = "# of passengers"
}

class StarshipListPresenter {
    
    // MARK: - Model, view, presenter
    
    private let router: StarshipListRouter
    private weak var view: StarshipListView?
    
    // MARK: - Properties
    
    private var starships: [Starship]?

    private(set) var selectedSortFieldIndex = 0
    private var selectedSortField: SortField { SortField.allCases[selectedSortFieldIndex] }
    
    // TODO: suppress .favourited if no items favourited
    var sortFieldTitles: [String] { SortField.allCases.map { $0.rawValue } }
    
    // TODO: for large numbers of starships and/or intensive sorting, might not be a good idea to not have this as a computed variable!
    private var starshipsSorted: [Starship]? {
        switch selectedSortField {
        case .natural:
            return starships
        case .favourited:
            return starships?.sorted {
                // If both favourited, use ordering by name
                if isFavourited($0) && isFavourited($1) { return $0.name.compare($1.name).rawValue > 0 }
                return isFavourited($0)
            }
        case .name:
            return starships?.sorted { $0.name.compare($1.name).rawValue < 0 }
        case .edited:
            return starships?.sorted { $0.edited.timeIntervalSince($1.edited) > 0 }
        case .cost:
            return starships?.sorted { $0.costInCredits ?? -1 > $1.costInCredits ?? -1 }
        case .passengers:
            return starships?.sorted { $0.passengers ?? -1 > $1.passengers ?? -1 }
        }
    }
    
    private(set) var errorLoading = false
    var loading: Bool { starships == nil && !errorLoading }    
    
    var numberOfStarships: Int? { starships?.count }
    var hasResultsToShow: Bool { (starships?.count ?? 0) > 0 }    
    
    // MARK: - Life-cycle
    
    required init(router: StarshipListRouter, view: StarshipListView?) {
        self.router = router
        self.view = view
    }
    
    func viewDidLoad() {
        // Load the starships
        self.view?.refresh()
        Task {
            do {
                self.starships = try await APIClient.sharedInstance.getStarships()
                self.view?.refresh()
            } catch {
                self.errorLoading = true
                self.view?.refresh()
            }
        }        

        self.view?.refresh()
/*        APIClient.sharedInstance.getStarships { [weak self] (starships, _, error) in
            guard let self = self else { return }
            
            // Store the result
            self.starships = starships
            
            // Check for errors, and if so flag error state
            if error != nil { self.errorLoading = true }
                
            // Refresh the view
            self.view?.refresh()
        } */
    }
    
    func viewWillAppear() {
        // Make sure the list is up to date, especially wrt favourites
        // TODO: probably better to use observers here
        self.view?.refresh()
    }
    
    // MARK: - Public functions
    
    func starship(atIndex index: Int) -> Starship? {
        guard let starshipsSorted = starshipsSorted, index < starshipsSorted.count else { return nil }
        return starshipsSorted[index]
    }
    
    func didToggleFavourte(_ starship: Starship) {
        // Remove if already favourited
        if isFavourited(starship) {
            AppManager.sharedInstance.favouritedStarships.removeAll { $0 == starship }
        } else {
            AppManager.sharedInstance.favouritedStarships.append(starship)
        }
        
        // Refresh the view
        self.view?.refresh()
    }
    
    func isFavourited(_ starship: Starship) -> Bool {
        return AppManager.sharedInstance.favouritedStarships.contains(starship)
    }
    
    func didSelectSortField(atIndex index: Int) {
        selectedSortFieldIndex = index
        
        // Simply refresh, our starshipsSorted computed property takes care of sorting
        self.view?.refresh()
    }
    
    func didSelectItem(atIndex index: Int) {
        guard let starship = starship(atIndex: index) else { return }
        router.presentStarshipDetails(starship)
    }
                
    // MARK: - Private functions
    
}

