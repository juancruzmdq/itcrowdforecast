//
//  itcrowdforecastTests.swift
//  itcrowdforecastTests
//
//  Created by Juan Cruz Ghigliani on 4/5/18.
//

import XCTest
@testable import itcrowdforecast

class CommonConfigTest: XCTestCase {
    
    func testCommonConfigCreate() {
        
        let config = Config(environment: .mock,
                            appVersion: "2.0",
                            buildNumber: "2",
                            locale: Locale(identifier: "es_AR"))
        
        XCTAssert(config.environment == .mock, "Wrong default Environment \(config.environment), expexted: .mock")
        XCTAssert(config.appVersion == "2.0", "Wrong App version \(config.appVersion), expexted: 2.0")
        XCTAssert(config.buildNumber == "2", "Wrong build number \(config.buildNumber), expexted: 2")
        XCTAssert(config.locale.languageCode == "es", "Wrong Locale info \(config.locale.languageCode ?? "Empty"), expexted: es")
        XCTAssert(config.locale.regionCode == "AR", "Wrong Locale info \(config.locale.regionCode ?? "Empty"), expexted: AR")
        
    }

    func testCommonConfigCreateFromBundle() {
        
        let bundle = Bundle(for: type(of: self))
        
        let config = Config(bundle: bundle, locale: Locale(identifier: "es_AR"))
        
        XCTAssert(config.environment == .mock, "Wrong default Environment \(config.environment), expexted: .mock")
        XCTAssert(config.appVersion == "2.0", "Wrong App version \(config.appVersion), expexted: 2.0")
        XCTAssert(config.buildNumber == "2", "Wrong build number \(config.buildNumber), expexted: 2")
        XCTAssert(config.locale.languageCode == "es", "Wrong Locale info \(config.locale.languageCode ?? "Empty"), expexted: es")
        XCTAssert(config.locale.regionCode == "AR", "Wrong Locale info \(config.locale.regionCode ?? "Empty"), expexted: AR")
        
    }
    
}
