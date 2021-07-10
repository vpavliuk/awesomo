//
//  OutgoingStateTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 01.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
import Combine
@testable import CoreMessaging

final class OutgoingStateTest: XCTestCase {
   typealias State = OutgoingState<TestPeer, TestMessage>
   var sut: State!
   var subscription: AnyCancellable?

   override func setUp() {
      super.setUp()
      sut = State()
   }

   func testInitial() {
      XCTAssertTrue(sut.outbox.isEmpty)
      XCTAssertTrue(sut.sent.isEmpty)
   }

   func testNotEqual1() {
      let notEqual = sut.copyWith(
         outbox: ["receiverId": [TestMessage()]]
      )
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual2() {
      let receiver = TestPeer()
      let notEqual = sut.copyWith(
         outbox: [receiver.id: [TestMessage(id: "1")]]
      )
      try! sut.send(
         message: TestMessage(id: "2"),
         to: receiver
      )
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual3() {
      let notEqual = sut.copyWith(
         sent: ["receiverId": [TestMessage()]]
      )
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual4() {
      let receiver = TestPeer()
      let notEqual = sut.copyWith(
         sent: [receiver.id: [TestMessage()]]
      )
      try! sut.send(
         message: TestMessage(),
         to: receiver
      )
      XCTAssertNotEqual(sut, notEqual)
   }

   func testEqualInitial() {
      XCTAssertEqual(sut, State())
   }

   func testEqual2() {
      let receiver = TestPeer()
      let equal = sut.copyWith(
         outbox: [receiver.id: [TestMessage()]]
      )
      try! sut.send(
         message: TestMessage(),
         to: receiver
      )
      XCTAssertEqual(sut, equal)
   }

   func testPublishing() {
      var notificationReceived = false
      let theMessage = TestMessage()

      subscription = sut.didEnqueueUpload.sink { upload in
         let theUpload = self.sut.getUpload(for: theMessage)!
         notificationReceived = (upload.id == theUpload.id)
      }

      try! sut.send(message: theMessage, to: TestPeer())
      XCTAssertTrue(notificationReceived)
   }

   func testSendDuplicatedMessageToSameReceiver() {
      let message = TestMessage()
      let receiver = TestPeer()
      try! sut.send(message: message, to: receiver)
      XCTAssertThrowsError(
         try sut.send(message: message, to: receiver),
         "Error should be thrown"
      ) { error in
         guard let coreError = error as? CoreMessagingError else {
            XCTFail("Error was thrown and that's fine, but the error type is wrong.")
            return
         }

         XCTAssertEqual(coreError, CoreMessagingError.invalidArgument(arg: "arbitrary"))
      }
   }

   func testSendDuplicatedMessageToDifferentReceivers() {
      let message = TestMessage()
      try! sut.send(message: message, to: TestPeer(id: "1"))
      XCTAssertThrowsError(
         try sut.send(message: message, to: TestPeer(id: "2")),
         "Error should be thrown"
      ) { error in
         guard let coreError = error as? CoreMessagingError else {
            XCTFail("Error was thrown and that's fine, but the error type is wrong.")
            return
         }

         XCTAssertEqual(coreError, CoreMessagingError.invalidArgument(arg: "arbitrary"))
      }
   }
}
