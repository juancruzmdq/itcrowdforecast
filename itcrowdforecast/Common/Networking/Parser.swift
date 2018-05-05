//
//  Parser.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

protocol Parseable {
    associatedtype ParserType: Parser
}

protocol Parser {
    associatedtype ParsedObject = Parseable
    static func parse(_ dictionaryRepresentation: [String: Any]) -> ParsedObject?
}
