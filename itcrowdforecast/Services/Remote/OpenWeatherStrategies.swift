//
//  OpenWeatherStrategies.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 10/5/18.
//

import Foundation

struct OpenWeatherResponseValidationStrategy: RemoteServiceResponseValidationStrategyProtocol {
    
    func serviceValidate(data: Data) -> RemoteServiceError? {
        
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            return RemoteServiceError.conversionToJsonFailed()
        }
        
        if let cod = dictionary["cod"] as? Double,
            let message = dictionary["message"] as? String {
            return RemoteServiceError.serviceFailed(code: String(format: "%.0f", cod), message: message)
        }
        return nil
    }
    
}
