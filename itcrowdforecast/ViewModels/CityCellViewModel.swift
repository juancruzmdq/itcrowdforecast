//
//  CityCellViewModel.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 6/5/18.
//

import Foundation

class CityCellViewModel {

    var cityName = ""
    var cityTemperature = ""
    var cityHumidity = ""

    var city: LocalCity? {
        didSet {
            guard let city = city else { return }
            self.cityName = city.name ?? ""
            self.cityTemperature = "\(String(format: "%.1f", city.temperature))°"
            self.cityHumidity = "\(city.humidity)%"
        }
    }

}
