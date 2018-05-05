//
//  City.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

class City {
    var uid: Double?
    var name: String?
    var latitude: Double?
    var longitude: Double?
}

extension City: Parseable {
    typealias ParserType = CityParser
}

struct CityParser: Parser {
    
    static func parse(_ dictionaryRepresentation: [String: Any]) -> City? {
        
        let city = City()
        
        city.uid = dictionaryRepresentation["id"] as? Double
        city.name = dictionaryRepresentation["name"] as? String
        if let coord = dictionaryRepresentation["coord"] as? [String: Any] {
            city.latitude = coord["lat"] as? Double
            city.longitude = coord["lon"] as? Double
        }
        
        return city
    }
}
