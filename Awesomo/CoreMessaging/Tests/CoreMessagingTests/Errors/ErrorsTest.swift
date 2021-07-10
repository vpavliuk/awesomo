//
//  ErrorsTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 15.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
@testable import CoreMessaging

final class ErrorsTest: XCTestCase {

   func testEqualityOfEqual() {
      let e1 = CoreMessagingError.invalidArgument(arg: "e1 argument")
      let e2 = CoreMessagingError.invalidArgument(arg: "e2 argument")
      XCTAssertEqual(e1, e2)

      let e3 = CoreMessagingError.stub
      let e4 = CoreMessagingError.stub
      XCTAssertEqual(e3, e4)
   }

   func testNotEqual() {
      let e1 = CoreMessagingError.invalidArgument(arg: "")
      let e2 = CoreMessagingError.stub
      XCTAssertNotEqual(e1, e2)
      XCTAssertNotEqual(e2, e1)
   }
   
   static var allTests = [
      ("testEqualityOfEqual", testEqualityOfEqual),
      ("testNotEqual", testNotEqual)
   ]
}
