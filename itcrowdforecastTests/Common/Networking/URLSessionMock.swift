//
//  URLSessionMock.swift
//  itcrowdforecastTests
//
//  Created by Juan Cruz Ghigliani on 18/5/18.
//

import XCTest
@testable import itcrowdforecast

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    var resumeWasCalled = false
    
    var completionHandler: URLSessionProtocol.DataTaskResult?
    
    func resume() {
        resumeWasCalled = true
    }
}

class URLSessionMock: URLSessionProtocol {
    var dataTaskWasCalled = false
    
    let dataTask: URLSessionDataTaskMock
    
    init(dataTask: URLSessionDataTaskMock) {
        self.dataTask = dataTask
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        self.dataTaskWasCalled = true
        self.dataTask.completionHandler = completionHandler
        return self.dataTask
    }
    
}
