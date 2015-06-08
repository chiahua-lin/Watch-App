//
//  BackendSessionTests.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/8/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import XCTest
import Watch_1373

class BackendSessionTests: XCTestCase {

    func testAuthenticationHeaderEncoding() {
        let authentication = BackendSessionAuthentication(username: "hello", password: "world")
        XCTAssertEqual("Basic aGVsbG86d29ybGQ=", authentication.headerValue)
    }

}
