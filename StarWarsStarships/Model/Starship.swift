//
//  Starship.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import Foundation

public struct Starship {
    
    // NB: the fields that we suspect we'll do math on, we'll have them as numbers, the rest as strings

    let name: String
    let model: String
    let manufacturer: String
    // NB: cost can be decimal, see: https://starwars.fandom.com/wiki/Galactic_Credit_Standard
    let costInCredits: Double?
    let length: String
    let maxAtmospheringSpeed: String
    let crew: String
    let passengers: Int?
    let cargoCapacity: String
    let consumables: String
    let hyperdriveRating: String
    let mglt: String
    let starshipClass: String
    let pilots: [String]
    let films: [String]
    let created: Date
    let edited: Date
    let urlString: String
    
}

// MARK: - Equatable

extension Starship: Equatable {

    public static func ==(lhs: Starship, rhs: Starship) -> Bool {
        // Assuming that model will be a unique identifier (name is probably a unique identifier too...)
        return lhs.model == rhs.model
    }
    
}
