//
//  TestRegex.swift
//  WebView
//
//  Created by Jason Pell on 21/2/2023.
//

import XCTest

final class TestRegex: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let localString = "http://google.com"
        let regexString = #"https?:"#
        XCTAssertTrue(localString.starts(with: regexString))
    }
}
