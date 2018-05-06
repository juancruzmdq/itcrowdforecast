//
//  CityDetailViewModel.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
import MapKit

class CityDetailViewModel {
    
    var city: LocalCity
    
    var title: String
    var temperature: String
    var humidity: String
    var pressure: String
    var minTemperature: String
    var maxTemperature: String
    var cityCoordinates: CLLocationCoordinate2D
    var cityRegion: MKCoordinateRegion

    init(for city: LocalCity) {
        self.city = city
        
        self.title = city.name ?? ""
        self.temperature = "\(String(format: "%.1f", city.temperature))°"
        self.humidity = "\(city.humidity)%"
        self.pressure = String(format: "%.1f", city.temperature)
        self.minTemperature = "\(String(format: "%.1f", city.minTemperature))°"
        self.maxTemperature = "\(String(format: "%.1f", city.maxTemperature))°"
        self.cityCoordinates = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        self.cityRegion = MKCoordinateRegion(center: self.cityCoordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    }

}
