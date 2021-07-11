//
//  StateTrackerTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 02.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
@testable import CoreMessaging

final class StateTrackerTest: XCTestCase {
   var sut: StateTracker<TestPeer, TestMessage>!

   typealias State = AppState<TestPeer, TestMessage>
   var state: State!
   let localPeerId = "localId"
   var serviceBrowser: TestBonjourBrowser!
   var networkSender: TestNetworkSender!
   var networkReceiver: TestNetworkReceiver!

   override func setUp() {
      super.setUp()

      state = State(localPeerId: localPeerId)
      sut = StateTracker(state: state)

      serviceBrowser = TestBonjourBrowser()
      networkSender = TestNetworkSender()
      networkReceiver = TestNetworkReceiver()
      sut.trackEvents(
         servicePublisher: serviceBrowser.publisher,
         uploadPublisher: networkSender.publisher,
         downloadPublisher: networkReceiver.publisher
      )
   }

   func testInitialState() {
      XCTAssertEqual(state, State(localPeerId: localPeerId))
   }

   func testOnePeerFound() {
      let service = TestBonjourService(name: "peerId.peerDisplay")
      serviceBrowser.dispatchFoundService(service)

      let expectedPeer = TestPeer(
         id: "peerId",
         displayName: "peerDisplay",
         bonjourService: service
      )
      let expectedState = State(
         localPeerId: localPeerId,
         peersState: PeersState(
            availablePeers: [expectedPeer]
         )
      )
      XCTAssertEqual(state, expectedState)
   }

   func testOneOfTwoUploadsSent() {
      let receiver = TestPeer()
      let outgoing1 = TestMessage(id: "1")
      let outgoing2 = TestMessage(id: "2")

      for message in [outgoing1, outgoing2] {
         try! state.outgoingState.send(
            message: message,
            to: receiver
         )
      }

      networkSender.dispatchUploadComplete(
         state.outgoingState.getUpload(for: outgoing2)!
      )

      let expectedOutgoingState = OutgoingState<TestPeer, TestMessage>().copyWith(
         outbox: [receiver.id: [outgoing1]],
         sent: [receiver.id: [outgoing2]]
      )

      let expectedState = State(
         localPeerId: localPeerId,
         incomingState: IncomingState(),
         outgoingState: expectedOutgoingState
      )
      XCTAssertEqual(state, expectedState)
   }

   func testOneDownloadReceived() {
      let senderId = "sender"
      let payload = 1

      networkReceiver.dispatchReceivedItem(
         NetworkMessage(sender: senderId, payload: payload)
      )

      let expectedState = State(
         localPeerId: localPeerId,
         incomingState: IncomingState(
            inbox: [senderId: [TestMessage(payload: payload)]]
         )
      )
      XCTAssertEqual(state, expectedState)
   }
}
