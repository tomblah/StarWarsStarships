//
//  Starship.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import Foundation

public struct Starship: Codable {
    
    enum StarshipCodingKey: CodingKey {
        case name, model, manufacturer, costInCredits, length, maxAtmospheringSpeed, crew, passengers, cargoCapacity, consumables, hyperdriveRating, mglt, starshipClass, pilots, films, created, edited, urlString
    }
    
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
    
    // MARK: - Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StarshipCodingKey.self)
        name = try container.decode(String.self, forKey: .name)
        model = try container.decode(String.self, forKey: .model)
        manufacturer = try container.decode(String.self, forKey: .manufacturer)
        costInCredits = try container.decode(Double.self, forKey: .costInCredits)
        length = try container.decode(String.self, forKey: .length)
        maxAtmospheringSpeed = try container.decode(String.self, forKey: .maxAtmospheringSpeed)
        crew = try container.decode(String.self, forKey: .crew)
        passengers = try container.decode(Int.self, forKey: .passengers)
        cargoCapacity = try container.decode(String.self, forKey: .cargoCapacity)
        consumables = try container.decode(String.self, forKey: .consumables)
        hyperdriveRating = try container.decode(String.self, forKey: .hyperdriveRating)
        mglt = try container.decode(String.self, forKey: .mglt)
        starshipClass = try container.decode(String.self, forKey: .starshipClass)
        pilots = try container.decode([String].self, forKey: .pilots)
        films = try container.decode([String].self, forKey: .films)
        created = try Starship.dateFormatter.date(from: container.decode(Date.self, forKey: .created))! // FIXME: make less brittle
        edited = try Starship.dateFormatter.date(from: container.decode(String.self, forKey: .edited))! // FIXME: make less brittle
        urlString = try container.decode(String.self, forKey: .urlString)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StarshipCodingKey.self)
        try container.encode(name, forKey: .name)
        try container.encode(model, forKey: .model)
        try container.encode(manufacturer, forKey: .manufacturer)
        try container.encode(costInCredits, forKey: .costInCredits)
        try container.encode(length, forKey: .length)
        try container.encode(maxAtmospheringSpeed, forKey: .maxAtmospheringSpeed)
        try container.encode(crew, forKey: .crew)
        try container.encode(passengers, forKey: .passengers)
        try container.encode(cargoCapacity, forKey: .cargoCapacity)
        try container.encode(consumables, forKey: .consumables)
        try container.encode(hyperdriveRating, forKey: .hyperdriveRating)
        try container.encode(starshipClass, forKey: .starshipClass)
        try container.encode(mglt, forKey: .mglt)
        try container.encode(starshipClass, forKey: .starshipClass)
        try container.encode(pilots, forKey: .pilots)
        try container.encode(films, forKey: .films)
        try container.encode(created, forKey: .created)
        try container.encode(edited, forKey: .edited)
        try container.encode(urlString, forKey: .urlString)
    }
    
}

// MARK: - Equatable

extension Starship: Equatable {

    public static func ==(lhs: Starship, rhs: Starship) -> Bool {
        // Assuming that model will be a unique identifier (name is probably a unique identifier too...)
        return lhs.model == rhs.model
    }
    
}
