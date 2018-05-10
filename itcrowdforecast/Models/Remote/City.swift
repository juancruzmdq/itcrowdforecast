//
//  City.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// City forecast using Parseable as example
class City {
    
    var uid: Double
    var name: String
    var latitude: Double?
    var longitude: Double?
    var temperature: Double?
    var pressure: Double?
    var humidity: Double?
    var minTemperature: Double?
    var maxTemperature: Double?
    
    init(uid: Double, name: String) {
        self.uid = uid
        self.name = name
    }
    
}

extension City: Parseable {
    typealias ParserType = CityParser
}

struct CityParser: Parser {
    
    static func parse(_ dictionaryRepresentation: [String: Any]) -> City? {

        guard let uid = dictionaryRepresentation["id"] as? Double,
            let name = dictionaryRepresentation["name"] as? String else {
                return nil
        }

        let city = City(uid: uid, name: name)
        
        if let coord = dictionaryRepresentation["coord"] as? [String: Any] {
            city.latitude = coord["lat"] as? Double
            city.longitude = coord["lon"] as? Double
        }

        if let main = dictionaryRepresentation["main"] as? [String: Any] {
            city.temperature = main["temp"] as? Double
            city.pressure = main["pressure"] as? Double
            city.humidity = main["humidity"] as? Double
            city.minTemperature = main["temp_min"] as? Double
            city.maxTemperature = main["temp_max"] as? Double
        }

        return city
    }
    
}
