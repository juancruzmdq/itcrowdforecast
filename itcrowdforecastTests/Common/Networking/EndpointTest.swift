//
//  EndpointTest.swift
//  itcrowdforecastTests
//
//  Created by Juan Cruz Ghigliani on 18/5/18.
//

import XCTest
@testable import itcrowdforecast

private class EndpointTestModel {
    
}

class EndpointTest: XCTestCase {
    
    func testEndpointCreate() {
        
        let endpoint = Endpoint<EndpointTestModel>(method: .get,
                                                   path: "path",
                                                   parameters: ["key": "value"],
                                                   strategies: [],
                                                   decode: { _ in
                                                    return Result.success(EndpointTestModel())
        })

        XCTAssertEqual(endpoint.method, .get)
        XCTAssertEqual(endpoint.path, "path")
        XCTAssertEqual(endpoint.parameters?.count, 1)
        XCTAssertEqual(endpoint.parameters?["key"] as? String, "value")
        
        let result = endpoint.decode(Data())
        
        switch result {
        case .success:
            break
        default:
            XCTFail("Decode failed, should return success with a EndpointTestModel's instance")
        }

    }
    
    func testEndpointDecodable() {
        
        let endpoint = Endpoint<EndpointTestModelDecodable>(method: .get,
                                                            path: "path")
        
        let result = endpoint.decode("{ \"key\": \"value\"}".data(using: .utf8)!)
        
        switch result {
        case let .success(entity):
            XCTAssert(entity.key == "value", "Decoded property 'key' should be equal to 'value'")
        default:
            XCTFail("Decode failed, should return success with a testEndpointDecodable instance")
        }
        
    }

    func testEndpointDecodableParseFailed() {
        
        let endpoint = Endpoint<EndpointTestModelDecodable>(method: .get,
                                                            path: "path")
        
        let result = endpoint.decode("{ \"invalid\" }".data(using: .utf8)!)
        
        switch result {
        case .success:
            XCTFail("Decode success, should return an error message")
        case let .failure(error):
            if case .objectParseFailed = error {
                break
            } else {
                XCTFail("Invalid type error \(result), waiting for: .objectParseFailed")
            }
        }
        
    }

    func testEndpointParseable() {
        
        let endpoint = Endpoint<EndpointTestModelParseable>(method: .get,
                                                            path: "path")

        let result = endpoint.decode("{ \"key\": \"value\"}".data(using: .utf8)!)
        
        switch result {
        case let .success(entity):
            XCTAssert(entity.key == "value", "Decoded property 'key' should be equal to 'value'")
        default:
            XCTFail("Decode failed, should return success with a EndpointTestModelParseable instance")
        }
        
    }
    
    func testEndpointParseableJsonFailed() {
        
        let endpoint = Endpoint<EndpointTestModelParseable>(method: .get,
                                                            path: "path")
        
        let result = endpoint.decode("{ \"invalid\" }".data(using: .utf8)!)
        
        switch result {
        case .success:
            XCTFail("Decode success, should return an error message")
        case let .failure(error):
            if case .conversionToJsonFailed = error {
                break
            } else {
                XCTFail("Invalid type error \(result), waiting for: .conversionToJsonFailed")
            }
        }
        
    }

    func testEndpointParseableEntityFailed() {
        
        let endpoint = Endpoint<EndpointTestModelParseable>(method: .get,
                                                            path: "path")
        
        let result = endpoint.decode("{ \"invalid_key\": \"value\" }".data(using: .utf8)!)
        
        switch result {
        case .success:
            XCTFail("Decode success, should return an error message")
        case let .failure(error):
            if case .objectParseFailed = error {
                break
            } else {
                XCTFail("Invalid type error \(result), waiting for: .objectParseFailed")
            }
        }
        
    }
}
