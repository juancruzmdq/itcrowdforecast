//
//  Predictions.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Google Predictions using Decodable
struct Predictions: Decodable {
    var predictions = [Prediction]()
}
