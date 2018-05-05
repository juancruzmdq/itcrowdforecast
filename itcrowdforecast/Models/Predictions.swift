//
//  Predictions.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
// TODO: revisar si es realmente necesario esto
class Predictions {
    var items = [Prediction]()
}

extension Predictions: Parseable {
    typealias ParserType = PredictionsParser
}

struct PredictionsParser: Parser {
    
    static func parse(_ dictionaryRepresentation: [String: Any]) -> Predictions? {
        let predictions = Predictions()
        
        if let items = dictionaryRepresentation["predictions"] as? [[String: Any]] {
            items.forEach {item in
                if let prediction = PredictionParser.parse(item) {
                    predictions.items.append(prediction)
                }
            }
        }
        return predictions
    }
    
}
