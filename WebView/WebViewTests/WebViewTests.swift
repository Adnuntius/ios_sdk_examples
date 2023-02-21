//
//  WebViewTests.swift
//  WebViewTests
//
//  Created by Jason Pell on 21/2/2023.
//

import XCTest

final class WebViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let regexString = "^[a-z]+://"
        XCTAssertTrue("http://google.com".range(of: regexString, options:.regularExpression) != nil)
        XCTAssertTrue("https://google.com".range(of: regexString, options:.regularExpression) != nil)
        XCTAssertTrue("ftp://google.com".range(of: regexString, options:.regularExpression) != nil)
        XCTAssertFalse("google.com".range(of: regexString, options:.regularExpression) != nil)
    }
}
