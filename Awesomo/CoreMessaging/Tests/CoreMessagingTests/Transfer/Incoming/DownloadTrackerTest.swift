//
//  DownloadTrackerTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 30.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
@testable import CoreMessaging

final class DownloadTrackerTest: XCTestCase {
   typealias State = IncomingState<TestPeer, TestMessage>
   var state: State!
   var sut: DownloadTracker<TestPeer, TestMessage>!
   var networkReceiver: TestNetworkReceiver!

   override func setUp() {
      super.setUp()

      networkReceiver = TestNetworkReceiver()
      state = State()
      sut = DownloadTracker(state: state)
      sut.trackDownloads(notifier: networkReceiver)
   }

   func testInitialState() {
      XCTAssertEqual(state, State())
   }

   func testReceivedOneItem() {
      networkReceiver.dispatchReceivedItem(
         NetworkMessage(sender: "sender1", payload: 1)
      )

      let expectedInbox: [TestPeer.ID: Set<TestMessage>] =
            ["sender1": [TestMessage(payload: 1)]]
      let expectedState = State(inbox: expectedInbox)
      XCTAssertEqual(state, expectedState)
   }

   func testReceivedThreeItems() {
      typealias ConcreteMessage = NetworkMessage<TestPeer, Int>
      let sender1 = "sender1"
      let sender2 = "sender2"
      let message1 = ConcreteMessage(sender: sender1, payload: 1)
      let message2 = ConcreteMessage(sender: sender1, payload: 2)
      let message3 = ConcreteMessage(sender: sender2, payload: 3)

      [message1, message2, message3]
            .forEach{networkReceiver.dispatchReceivedItem($0)}

      let expectedState = State(
         inbox: [
            sender1: [
               TestMessage(payload: message1.payload),
               TestMessage(payload: message2.payload)
            ],
            sender2: [TestMessage(payload: message3.payload)]
         ]
      )
      XCTAssertEqual(state, expectedState)
   }
}
