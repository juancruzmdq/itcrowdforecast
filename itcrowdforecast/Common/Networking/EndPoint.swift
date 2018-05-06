//
//  EndPoint.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
}

protocol EndPointProtocol {
    var path: String { get }
    var parameters: [String: Any] { get }
    var httpMethod: HTTPMethod { get }
}
