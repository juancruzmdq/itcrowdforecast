//
//  RemoteProviderService.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

enum Result<T> {
    case success(_: T)
    case failure(_: RemoteProviderServiceError)
}

enum RemoteProviderServiceError: Error {
    case dataTaskError(_: String)
    case invalidURLError()
    case emptyDataError()
    case conversionToJsonFailed()
    case objectParseFailed()
    case serviceFailed(code: String, message: String)
}

protocol RemoteProviderServiceDelegate: class {
    func remoteProviderServiceValidate(response: [String: Any]) -> RemoteProviderServiceError?
}

class RemoteProviderService {
    
    let session: URLSession
    let baseURL: URL
    
    weak var delegate: RemoteProviderServiceDelegate?

    init(baseUrl: URL, session: URLSession) {
        self.session = session
        self.baseURL = baseUrl
    }

    func call<T: Parseable>(endpoint: EndPointProtocol, completion: @escaping (Result<T>) -> Void) {
        self.callWithCompletionWrapper(endpoint: endpoint) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func callWithCompletionWrapper<T: Parseable>(endpoint: EndPointProtocol, completion: @escaping (Result<T>) -> Void) {
        
        guard let url = self.buildURL(for: endpoint) else {
            completion(.failure(RemoteProviderServiceError.invalidURLError()))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        var dataTask: URLSessionDataTask?
        dataTask = self.session.dataTask(with: url) { [weak self] data, _, error in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion(.failure(RemoteProviderServiceError.dataTaskError(error.localizedDescription)))
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
                completion(.failure(RemoteProviderServiceError.emptyDataError()))
            }
        }
        dataTask?.resume()
    }
    
}

private extension RemoteProviderService {
    
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
        default:
            return self.baseURL.appendingPathComponent(endpoint.path)
        }
        
        return nil
        
    }

}
