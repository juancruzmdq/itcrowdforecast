//
//  CityTableViewCell.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 6/5/18.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!

    var viewModel: CityCellViewModel? {
        didSet {
            self.displayModelInfo()
        }
    }
    
    private func displayModelInfo() {
        self.nameLabel.text = viewModel?.cityName
        self.tempLabel.text = viewModel?.cityTemperature
        self.humidityLabel.text = viewModel?.cityHumidity
    }
}
