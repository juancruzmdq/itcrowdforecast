//
//  Parser.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Protocol to be implemented by a model that can be parsed after the service call finish
protocol Parseable {
    associatedtype ParserType: Parser
}

/// Protocol to be implemented by a class that can parse an API response to a Model object
protocol Parser {
    associatedtype ParsedObject = Parseable
    static func parse(_ dictionaryRepresentation: [String: Any]) -> ParsedObject?
}
