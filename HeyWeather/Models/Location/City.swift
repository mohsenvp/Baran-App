//
//  City.swift
//  WeatherApp
//
//  Created by RezaRg on 7/28/20.
//

import Foundation
import SwiftyJSON

struct City : Identifiable, Codable, Equatable, Hashable {
    
    var id : Int
    var name : String
    var state : String
    var country : String
    var location : Location
    var isCurrentLocation: Bool {
        return id == 0
    }
    
    var placeMarkCityName: String! {
        get {
            return _placeMarkCityName ?? name
        }
        set {
            _placeMarkCityName = newValue
        }
    }
    private var _placeMarkCityName: String?
    
    
    var flagURLString: String?
    
    static func ==(lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
    
    init () {
        self.id = 123170
        self.name = "8 Avenue des Champs Elysées"
        self.state = ""
        self.country = "FR"
        self.location = Location()
        self.placeMarkCityName = "Paris"
    }
    
    init (id:Int, name:String, state:String, country:String, location : Location, placeMarkCityName : String = "") {
        self.id = id
        self.name = name
        self.state = state
        self.country = country
        self.location = location
        self.placeMarkCityName = placeMarkCityName
    }
    
    init (json : JSON) {
        self.id = json["id"].int!
        self.name = json["name"].string!
        self.state = json["state"].string!
        self.country = json["country"].string!
        if json["location"].exists() {///this is used for encoding the same class as json (watchos)
            self.location = Location(json: json["location"])
        }else {
            self.location = Location(json: json["coord"])
        }

        self.placeMarkCityName = json["name"].string!
        self.flagURLString = "https://v2.heyweatherapp.com/images/".appending("/\(json["flag"].stringValue)")
    }
    
    
    func printCity() {
        let a = "id = \(id) | placeMarkCityName = \(placeMarkCityName!) | name = \(name) | country = \(country) | state = \(state)"
        print(a)
    }
}
