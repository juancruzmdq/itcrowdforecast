//
//  CityDetailViewController.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit
import MapKit

class CityDetailViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var viewModel: CityDetailViewModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.displayModelInfo()
    }
    
    private func displayModelInfo() {
        guard let viewModel = self.viewModel else { return }
        
        self.title = viewModel.title
        self.tempLabel.text = viewModel.temperature
        self.pressureLabel.text = viewModel.pressure
        self.humidityLabel.text = viewModel.humidity
        self.maxLabel.text = viewModel.maxTemperature
        self.minLabel.text = viewModel.minTemperature
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = viewModel.cityCoordinates
        self.mapView.addAnnotation(annotation)
        self.mapView.region = viewModel.cityRegion
    }
    
}
