//
//  APIClient.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//


import Foundation
import os
import Alamofire
import SwiftyJSON

enum APIError: Error {
    case parsingError
}

class APIClient {
    
    // MARK: - Singleton

    static let sharedInstance = APIClient()
    
    // MARK: - Constants
    
    enum API {
        static let starshipsRoute = "https://swapi.dev/api/starships/"
        
        // TODO: move somewhere more sensible
        static var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            // See: https://stackoverflow.com/a/39433900/1017700
            // TODO: there's probably a much cleaner way of doing this!
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            return dateFormatter
        }
    }
        
    // MARK: - Public functions
    
    func getStarships() async throws -> [Starship] {
        // TODO: constant
        let url = URL(string: API.starshipsRoute)!
                
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let starshipsJson = JSON(data)["results"].array else {
                os_log("Could not retrieve starships from %{public}@, aborting.", log: Log.api, type: .error, "https://swapi.dev/api/starships/")
                throw APIError.parsingError
            }
            
            let starships: [Starship] = starshipsJson.compactMap { self.parseStarshipJson($0) }
            return starships
        } catch let error {
            print(String(describing: error))
            return [Starship]()
        }
    }
        
    // MARK: - Private functions
    
    private func parseStarshipJson(_ starshipJson: JSON) -> Starship? {
        // TODO: In a real-life scenario these objects (and the parsing code) would probably be automatically generated via an `OpenAPI` doc and generator or equivalent. Here we just do what's required to get the data
        guard let name = starshipJson["name"].string else { os_log("Could not parse starship name, skipping a starship.", type: .error); return nil }
        
        guard let model = starshipJson["model"].string else { os_log("Could not parse model for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let manufacturer = starshipJson["manufacturer"].string else { os_log("Could not parse manufacturer for %{public}@, skipping.", type: .error, name); return nil }

        let costInCredits: Double?
        if let costInCreditsString = starshipJson["cost_in_credits"].string {
            costInCredits = Double(costInCreditsString)
        } else {
            costInCredits = nil
        }
        
        guard let length = starshipJson["length"].string else { os_log("Could not parse length for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let maxAtmospheringSpeed = starshipJson["max_atmosphering_speed"].string else { os_log("Could not parse max_atmosphering_speed for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let crew = starshipJson["crew"].string else { os_log("Could not parse crew for %{public}@, skipping.", type: .error, name); return nil }
        
        let passengers: Int?
        if let passengersString = starshipJson["passengers"].string?.replacingOccurrences(of: ",", with: "") {
            passengers = Int(passengersString)
        } else {
            passengers = nil
        }
        
        guard let cargoCapacity = starshipJson["cargo_capacity"].string else { os_log("Could not parse cargoCapacity for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let consumables = starshipJson["consumables"].string else { os_log("Could not parse consumables for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let hyperdriveRating = starshipJson["hyperdrive_rating"].string else { os_log("Could not parse hyperdrive_rating for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let mglt = starshipJson["MGLT"].string else { os_log("Could not parse MGLT for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let starshipClass = starshipJson["starship_class"].string else { os_log("Could not parse starship_class for %{public}@, skipping.", type: .error, name); return nil }
        
        // NB: for this exercise, if there's any issues parsing the individual pilots or films, we won't fail the parsing of the starship (keeps things simpler!)
        guard let pilots: [String] = (starshipJson["pilots"].array?.compactMap { $0.string }) else { os_log("Could not parse pilots for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let films: [String] = (starshipJson["films"].array?.compactMap { $0.string }) else { os_log("Could not parse films for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let createdString = starshipJson["created"].string, let createdDate = API.dateFormatter.date(from: createdString) else { os_log("Could not parse created for %{public}@, skipping.", type: .error, name); return nil }
        
        guard let editedString = starshipJson["edited"].string, let editedDate = API.dateFormatter.date(from: editedString) else { os_log("Could not parse edited for %{public}@, skipping.", type: .error, name); return nil }
                
        guard let urlString = starshipJson["url"].string else { os_log("Could not parse url for %{public}@, skipping.", type: .error, name); return nil }

        return Starship(name: name, model: model, manufacturer: manufacturer, costInCredits: costInCredits, length: length, maxAtmospheringSpeed: maxAtmospheringSpeed, crew: crew, passengers: passengers, cargoCapacity: cargoCapacity, consumables: consumables, hyperdriveRating: hyperdriveRating, mglt: mglt, starshipClass: starshipClass, pilots: pilots, films: films, created: createdDate, edited: editedDate, urlString: urlString)
    }
        
}
