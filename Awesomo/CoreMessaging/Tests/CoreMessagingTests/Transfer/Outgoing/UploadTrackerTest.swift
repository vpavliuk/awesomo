//
//  UploadTrackerTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 30.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
@testable import CoreMessaging

final class UploadTrackerTest: XCTestCase {
   typealias State = OutgoingState<TestPeer, TestMessage>
   var state: State!
   var sut: UploadTracker<TestPeer, TestMessage>!
   var networkSender: TestNetworkSender!

   override func setUp() {
      super.setUp()

      networkSender = TestNetworkSender()
      state = State()
      sut = UploadTracker(state: state)
      sut.trackUploads(notifier: networkSender)
   }

   func testInitialState() {
      XCTAssertEqual(state, State())
   }

   func testSentUnknownItem() {
      let rightPeer = TestPeer(id: "right")
      let message = TestMessage()
      try! state.send(
         message: message,
         to: rightPeer
      )

      let unexpectedUpload = Upload(
         receiver: TestPeer(id: "wrong"),
         domainMessage: message
      )
      self.networkSender.dispatchUploadComplete(unexpectedUpload)

      let expectedState = State().copyWith(
         outbox: [rightPeer.id: [message]]
      )
      XCTAssertEqual(state, expectedState)
   }

   func testSentOneKnownItemOfTwo() {
      let receiver = TestPeer()
      let sentMessage = TestMessage(id: "known1")
      let notSentMessage = TestMessage(id: "known2")
      [sentMessage, notSentMessage]
            .forEach{try! state.send(message: $0, to: receiver)}

      networkSender.dispatchUploadComplete(
         state.getUpload(for: sentMessage)!
      )

      let expectedState = State().copyWith(
         outbox: [receiver.id: [notSentMessage]],
         sent: [receiver.id: [sentMessage]]
      )
      XCTAssertEqual(state, expectedState)
   }

   func testSentAllItems() {
      var receiverIds = Set<String>()
      for i in 0..<Int.random(in: 0...1000) {
         let receiverId = "\(Int.random(in: 0...10))"
         receiverIds.insert(receiverId)
         try! state.send(
            message: TestMessage(id: "\(i)"),
            to: TestPeer(id: receiverId)
         )
      }

      let expectedSentBox = state.outbox
      let allMessages: [TestMessage] = state.outbox.values.flatMap{Array($0)}
      for message in allMessages {
         networkSender.dispatchUploadComplete(
            state.getUpload(for: message)!
         )
      }

      let expectedOutbox = Dictionary(
         uniqueKeysWithValues: zip(
            receiverIds,
            Array(repeating: Set<TestMessage>(), count: receiverIds.count)
         )
      )
      let expectedState = State().copyWith(
         outbox: expectedOutbox,
         sent: expectedSentBox
      )
      XCTAssertEqual(state, expectedState)
   }
}
