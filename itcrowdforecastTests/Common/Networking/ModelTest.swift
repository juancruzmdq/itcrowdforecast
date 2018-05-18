//
//  ModelTest.swift
//  itcrowdforecastTests
//
//  Created by Juan Cruz Ghigliani on 18/5/18.
//

import XCTest
@testable import itcrowdforecast

class EndpointTestModelDecodable: Decodable {
    var key: String?
}

class EndpointTestModelParseable: Parseable {
    typealias ParserType = EndpointTestModelParseableParser
    var key: String?
}

struct EndpointTestModelParseableParser: Parser {
    
    static func parse(_ dictionaryRepresentation: [String: Any]) -> EndpointTestModelParseable? {
        if let key = dictionaryRepresentation["key"] as? String {
            let model = EndpointTestModelParseable()
            model.key = key
            return model
        }
        return nil
    }
}
