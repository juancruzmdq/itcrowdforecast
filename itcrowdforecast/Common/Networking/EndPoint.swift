//
//  EndPoint.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Request type for HTTP protocol
///
/// - GET: Plain get request.
enum HTTPMethod: String {
    case GET
// Some day this values could be usefull.
//    case POST
//    case PUT
//    case DELETE
}

/// Protocol that should implement any object that make reference to a API endpoint.
protocol EndPointProtocol {
    
    /// Route of the API resource.
    var path: String { get }
    
    /// Dictionary with request parameter (key, value).
    var parameters: [String: Any] { get }
    
    /// HTTPMethod required by the API endPoint
    var httpMethod: HTTPMethod { get }
}
