//
//  Prediction.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

class Prediction {
    var description: String?
}

extension Prediction: Parseable {
    typealias ParserType = PredictionParser
}

struct PredictionParser: Parser {
    
    static func parse(_ dictionaryRepresentation: [String: Any]) -> Prediction? {
        let prediction = Prediction()
        prediction.description = dictionaryRepresentation["description"] as? String
        return prediction
    }
    
}
