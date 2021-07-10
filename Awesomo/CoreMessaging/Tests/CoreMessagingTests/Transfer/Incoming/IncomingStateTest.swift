//
//  IncomingStateTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 07.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
@testable import CoreMessaging

final class IncomingStateTest: XCTestCase {
   typealias State = IncomingState<TestPeer, TestMessage>
   var sut: State!

   override func setUp() {
      super.setUp()
      sut = State()
   }

   func testInitial() {
      XCTAssertTrue(sut.inbox.isEmpty)
   }

   func testNotEqual1() {
      let notEqual = State(inbox: ["peerId": [TestMessage(payload: 0)]])
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual2() {
      let notEqual = State(inbox: ["peerId": [TestMessage(payload: 0)]])

      sut.inbox = ["peerId": [TestMessage(payload: 1)]]
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual3() {
      let notEqual = State(inbox: ["peerId1": [TestMessage(payload: 0)]])

      sut.inbox = ["peerId2": [TestMessage(payload: 0)]]
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual4() {
      let notEqual = State(inbox: ["peerId1": [TestMessage(payload: 0)]])

      sut.inbox["peerId1"] = [TestMessage(payload: 0)]
      sut.inbox["peerId2"] = [TestMessage(payload: 1)]
      XCTAssertNotEqual(sut, notEqual)
   }

   func testEqual1() {
      let equal = State(inbox: ["peerId": [TestMessage(payload: 0)]])

      sut.inbox = ["peerId": [TestMessage(payload: 0)]]
      XCTAssertEqual(sut, equal)
   }

   func testEqual2() {
      let equal = State(inbox: ["peerId": [TestMessage(payload: 0)]])

      sut.inbox = ["peerId": [TestMessage(payload: 0)]]
      XCTAssertEqual(sut, equal)
   }

   func testEqual3() {
      let messages: [TestPeer.ID: Set<TestMessage>] = [
         "peerId1": [TestMessage(payload: 0)],
         "peerId2": [TestMessage(payload: 1)]
      ]
      let equal = State(inbox: messages)

      sut.inbox = messages
      XCTAssertEqual(sut, equal)
   }
}
