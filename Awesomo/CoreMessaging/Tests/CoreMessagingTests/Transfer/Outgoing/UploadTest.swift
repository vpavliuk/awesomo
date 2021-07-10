//
//  UploadTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 08.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
@testable import CoreMessaging

final class UploadTest: XCTestCase {

   func testIdNotEqual() {
      let receiver = TestPeer()
      let message = TestMessage()
      let upload1 = Upload(
         receiver: receiver,
         domainMessage: message
      )
      let upload2 = Upload(
         receiver: receiver,
         domainMessage: message
      )
      XCTAssertNotEqual(upload1.id, upload2.id)
   }
}
