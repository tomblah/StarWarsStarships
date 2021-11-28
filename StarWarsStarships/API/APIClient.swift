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

class APIClient {
    
    // MARK: - Singleton

    static let sharedInstance = APIClient()
    
    // MARK: - Constants
    
    enum API {
        static let urlString = "https://swapi.dev/api"
        static let starshipsPath = "starships"
        
        static let invalidRequestHttpCode = 400

        static var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            // See: https://stackoverflow.com/a/39433900/1017700
            // TODO: there's probably a much cleaner way of doing this!
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            return dateFormatter
        }
    }
    
    // MARK: - Public functions
    
    // The starship API is a little weird in that the "next" (and "previous" page) urls are given as absolute URLs, i.e. they could point to entirely different sites (although highly unlikely)!
    // So to support pagination, our code is a little messy...
    func getStarships(usingSpecificPageUrlString specificPageUrlString: String? = nil, completion: @escaping (_ starships: [Starship]?, _ nextPageUrlString: String?, _ error: Error?) -> Void) {
        // If we have a specific page, use that, otherwise construct the URL
        let starshipsUrlString = specificPageUrlString ?? API.urlString + "/" + API.starshipsPath
        
        // Make the call
        os_log("Making call to %{public}@", log: Log.api, type: .info, starshipsUrlString)
        Alamofire.request(starshipsUrlString).responseString { [weak self] response in
            guard let self = self else { return }
            
            // Attempt to get the starships JSON objects
            guard let data = response.data, let starshipsJson = JSON(data)["results"].array else {
                os_log("Could not retrieve starships from %{public}@, aborting.", log: Log.api, type: .error, starshipsUrlString)
                // TODO: probably want to put in an error message a user info dictionary and include in the error object
                completion(nil, nil, NSError(domain: AppManager.sharedInstance.bundleIdentifier, code: API.invalidRequestHttpCode, userInfo: nil))
                return
            }

            // Manually parse the result into our native starship objects
            // NB: for simplicity, we'll skip any failings to parse starship objects, but print the error to the console
            let starships: [Starship] = starshipsJson.compactMap { self.parseStarshipJson($0) }
            
            // Grab the next page url string
            // NB: we'll probably won't need this for the scope of this coding challenge
            let nextPageUrlString = JSON(data)["next"].string
            
            os_log("Retrieved \(starshipsJson.count) and successfully parsed \(starships.count) starships from \(starshipsUrlString). Next page url: \(nextPageUrlString != nil ? nextPageUrlString! : "[no more pages]")")
            
            completion(starships, nextPageUrlString, nil)
            
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
