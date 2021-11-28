//
//  AppManager.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import Foundation

import os

class AppManager {

    // MARK: - Singleton
    
    static let sharedInstance = AppManager()
    
    // MARK: - Properties
    
    // TODO: probably shouldn't be force unwrapping this as it can be nil: https://stackoverflow.com/a/40363955/1017700, but I deem it out of scope for this coding challenge ;-).
    var bundleIdentifier: String { Bundle.main.bundleIdentifier! }
    
    // TODO: to make favouritedStarships persistable to, say, userdefaults, we'll simply make Starship codable and have custom getters and setters which write the array to user defaults (assuming that typically users will only persist ~10 or so favourites, so a negligable performance hit reading/writing user defaults)
    var favouritedStarships = [Starship]()
        
}
