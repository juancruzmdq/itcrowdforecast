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
  
}

private extension CityTableViewCell {
    
    func displayModelInfo() {
        self.nameLabel.text = viewModel?.name
        self.tempLabel.text = viewModel?.temperature
        self.humidityLabel.text = viewModel?.humidity
    }
    
}
