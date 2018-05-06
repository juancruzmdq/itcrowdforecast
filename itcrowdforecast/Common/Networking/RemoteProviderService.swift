//
//  RemoteProviderService.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation


/// Result wrapper for Service's responses
///
/// - success: The service finish successfuly and return an object from the App model
/// - failure: There was a issue with the service, use this value to report the error
enum Result<T> {
    case success(_: T)
    case failure(_: RemoteProviderServiceError)
}

enum RemoteProviderServiceError: Error {
    case dataTaskFailed(_: String)
    case invalidURL()
    case emptyDataResponse()
    case conversionToJsonFailed()
    case objectParseFailed()
    case serviceFailed(code: String, message: String)
}

/// The service will use this protocol to delegate some responsabilities to the service owner.
protocol RemoteProviderServiceDelegate: class {
    
    /// Notify a new response from the service, the delegate can parse the response and report an error.
    ///
    /// - Parameter response: Service response.
    /// - Returns: An error instance if exist or nil if all is Ok.
    func remoteProviderServiceValidate(response: [String: Any]) -> RemoteProviderServiceError?
}

/// Class that works as interface of a remot web service
class RemoteProviderService {
    
    private let session: URLSession
    private let baseURL: URL
    
    weak var delegate: RemoteProviderServiceDelegate?

    init(baseUrl: URL, session: URLSession) {
        self.session = session
        self.baseURL = baseUrl
    }

    /// Call an specific endpoint, when finish execute completion block in main thread
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint to call
    ///   - completion: Block to be called when Endpoint's call finish
    func call<T: Parseable>(endpoint: EndPointProtocol, completion: @escaping (Result<T>) -> Void) {
        self.callWithCompletionWrapper(endpoint: endpoint) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
}

private extension RemoteProviderService {
    
    private func callWithCompletionWrapper<T: Parseable>(endpoint: EndPointProtocol, completion: @escaping (Result<T>) -> Void) {
        
        guard let url = self.buildURL(for: endpoint) else {
            completion(.failure(RemoteProviderServiceError.invalidURL()))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        var dataTask: URLSessionDataTask?
        dataTask = self.session.dataTask(with: url) { [weak self] data, _, error in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion(.failure(RemoteProviderServiceError.dataTaskFailed(error.localizedDescription)))
            } else if let data = data {
                guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                    completion(.failure(RemoteProviderServiceError.conversionToJsonFailed()))
                    return
                }
                
                if let error = strongSelf.delegate?.remoteProviderServiceValidate(response: dictionary) {
                    completion(.failure(error))
                    return
                }
                
                guard let object = T.ParserType.parse(dictionary) as? T else {
                    completion(.failure(RemoteProviderServiceError.objectParseFailed()))
                    return
                }
                
                completion(.success(object))
                
            } else {
                completion(.failure(RemoteProviderServiceError.emptyDataResponse()))
            }
        }
        dataTask?.resume()
    }
    
    func buildURL(for endpoint: EndPointProtocol) -> URL? {
        
        switch endpoint.httpMethod {
        case .GET:
            if var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false) {
                urlComponents.queryItems = endpoint.parameters.compactMap {arg in
                    let (key, value) = arg
                    return URLQueryItem(name: key, value: value as? String)
                }
                urlComponents.path += endpoint.path
                return urlComponents.url
            }
        }
        
        return nil
        
    }

}
