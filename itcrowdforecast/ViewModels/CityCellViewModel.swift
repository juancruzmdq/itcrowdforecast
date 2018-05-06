//
//  CityCellViewModel.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 6/5/18.
//

import Foundation

class CityCellViewModel {

    var city: LocalCity
    var name = ""
    var temperature = ""
    var humidity = ""
    
    init(for city: LocalCity) {
        self.city = city
        self.name = city.name ?? ""
        self.temperature = "\(String(format: "%.1f", city.temperature))°"
        self.humidity = "\(city.humidity)%"
    }

}
