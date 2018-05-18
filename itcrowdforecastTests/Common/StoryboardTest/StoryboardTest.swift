//
//  StoryboardTest.swift
//  itcrowdforecastTests
//
//  Created by Juan Cruz Ghigliani on 18/5/18.
//

import XCTest
@testable import itcrowdforecast

enum TestStoryboard: String, Storyboard {
    case storyboardTest = "StoryboardTest"
}

class StoryboardTest: XCTestCase {
        
    func testStoryboardCreate() {
        
        let bundle = Bundle(for: type(of: self))
        
        XCTAssertNotNil(TestStoryboard.storyboardTest.storyboard(in: bundle), "Storyboard should be created succesfully")
        
        XCTAssertNotNil(TestStoryboard.storyboardTest.storyboard(in: bundle)?.instantiateInitialViewController(), "Initial view controller should be created succesfully")
        
    }
    
}
