//
//  RemoteServiceTest.swift
//  itcrowdforecastTests
//
//  Created by Juan Cruz Ghigliani on 18/5/18.
//

import XCTest
@testable import itcrowdforecast

private class URLSessionDataTaskMockSuccess: URLSessionDataTaskMock {
    override func resume() {
        super.resume()
        completionHandler?("{ invalid }".data(using: .utf8), nil, nil) // data, response, error
    }
}

class RemoteServiceTest: XCTestCase {
    
    func testExample() {
        
        let expectation = XCTestExpectation(description: "Endpoint should fail.")
        
        let service = RemoteService(baseUrl: URL(fileURLWithPath: "test_base_url"),
                                   session: URLSessionMock(dataTask: URLSessionDataTaskMockSuccess()),
                                   strategies: [])
        
        let endpoint = Endpoint<EndpointTestModelDecodable>(method: .get,
                                                            path: "path")

        let dataTask = service.call(endpoint: endpoint) { result in
            
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        } as? URLSessionDataTaskMock

        XCTAssert(dataTask?.resumeWasCalled ?? false)

        wait(for: [expectation], timeout: 1.0)
    
    }

}
