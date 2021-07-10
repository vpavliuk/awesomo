//
//  PeerTrackerTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 16.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
@testable import CoreMessaging

final class PeerTrackerTest: XCTestCase {
   let localId = "localId"
   var sut: PeerTracker<TestPeer>!
   var browser: TestBonjourBrowser!
   var state: PeersState<TestPeer>!

   override func setUp() {
      super.setUp()

      browser = TestBonjourBrowser()
      state = PeersState()
      sut = PeerTracker(localPeerId: localId, state: state)
      sut.trackPeers(serviceBrowser: browser)
   }

   func testInitialState() {
      XCTAssertEqual(state, PeersState())
   }

   func testFoundLocalPeer() {
      let localServiceName = localId
      let localService = TestBonjourService(name: localServiceName)

      browser.dispatchFoundService(localService)

      XCTAssertEqual(state, PeersState())
   }

   func testUnexpectedLoss() {
      let unknownService = TestBonjourService(name: "unknownService")

      browser.dispatchLostService(unknownService)

      XCTAssertEqual(state, PeersState())
   }

   func testFoundNonLocalPeer() {
      let id = "nonLocalId"
      let displayName = "NonLocal1"
      let serviceName = BonjourNameComposer<TestPeer>().name(
         fromId: id,
         displayName: displayName
      )
      let nonLocalService = TestBonjourService(name: serviceName)

      browser.dispatchFoundService(nonLocalService)

      let expectedPeer = TestPeer(
         id: id,
         displayName: displayName,
         bonjourService: nonLocalService
      )
      let expectedState = PeersState(availablePeers: [expectedPeer])
      XCTAssertEqual(state, expectedState)
   }

   func testFoundOneInvalidService() {
      let invalidService = TestBonjourService(name: "Invalid Service Name")
      browser.dispatchFoundService(invalidService)
      XCTAssertEqual(state, PeersState())
   }

   func testFoundTwoPeersOneValid() {
      let validId = "nonLocalId"
      let validDisplayName = "NonLocal1"
      let serviceName = BonjourNameComposer<TestPeer>().name(
         fromId: validId,
         displayName: validDisplayName
      )
      let validService = TestBonjourService(name: serviceName)
      let invalidService = TestBonjourService(name: "invalid")
      let events = Set(
         [invalidService, validService].map{ service in
            return TestServiceEvent(type: .found, object: service)
         }
      )
      assert(events.count == 2)

      browser.publisher.send(events)

      let expectedPeer = TestPeer(
         id: validId,
         displayName: validDisplayName,
         bonjourService: validService
      )
      let expectedState = PeersState(availablePeers: [expectedPeer])
      XCTAssertEqual(state, expectedState)
   }

   func testFoundTwoValidPeersWithInterval() {
      let id1 = "id1"
      let displayName = "display"
      let serviceName1 = BonjourNameComposer<TestPeer>().name(
         fromId: id1,
         displayName: displayName
      )
      let service1 = TestBonjourService(name: serviceName1)

      let id2 = "id2"
      let serviceName2 = BonjourNameComposer<TestPeer>().name(
         fromId: id2,
         displayName: displayName
      )
      let service2 = TestBonjourService(name: serviceName2)

      browser.dispatchFoundService(service1)
      let delayExpectation = expectation(description: "A delay between 2 events")
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
         self.browser.dispatchFoundService(service2)
         delayExpectation.fulfill()
      }
      waitForExpectations(timeout: 1)

      let peer1 = TestPeer(
         id: id1,
         displayName: displayName,
         bonjourService: service1
      )
      let peer2 = TestPeer(
         id: id2,
         displayName: displayName,
         bonjourService: service2
      )
      let expectedState = PeersState(availablePeers: [peer1, peer2])
      XCTAssertEqual(state, expectedState)
   }
   
   func testTwoFoundAndOneLostAfterSomeTime() {
      let id1 = "id1"
      let displayName = "display"
      let serviceName1 = BonjourNameComposer<TestPeer>().name(
         fromId: id1,
         displayName: displayName
      )
      let service1 = TestBonjourService(name: serviceName1)

      let id2 = "id2"
      let serviceName2 = BonjourNameComposer<TestPeer>().name(
         fromId: id2,
         displayName: displayName
      )
      let service2 = TestBonjourService(name: serviceName2)
      let events = Set(
         [service1, service2].map{ service in
            return TestServiceEvent(type: .found, object: service)
         }
      )

      browser.publisher.send(events)

      let delayExpectation = expectation(description: "A delay before peer loss")
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
         self.browser.dispatchLostService(service1)
         delayExpectation.fulfill()
      }
      waitForExpectations(timeout: 1)

      let peer1 = TestPeer(
         id: id1,
         displayName: displayName,
         bonjourService: service1
      )
      let peer2 = TestPeer(
         id: id2,
         displayName: displayName,
         bonjourService: service2
      )
      let expectedState = PeersState(availablePeers: [peer2], lostPeers: [peer1])
      XCTAssertEqual(state, expectedState)
   }

   func testFoundWithNewDisplayNameAfterLoss() {
      let id = "id"
      let displayName = "display"
      let serviceName1 = BonjourNameComposer<TestPeer>().name(
         fromId: id,
         displayName: displayName
      )
      let service1 = TestBonjourService(name: serviceName1)

      let changedDisplayName = "Changed Display Name"
      let serviceName2 = BonjourNameComposer<TestPeer>().name(
         fromId: id,
         displayName: changedDisplayName
      )
      let service2 = TestBonjourService(name: serviceName2)

      browser.dispatchFoundService(service1)
      let delayExpectation = expectation(description: "A delay between events")
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
         self.browser.dispatchLostService(service1)
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.browser.dispatchFoundService(service2)
            delayExpectation.fulfill()
         }
      }
      waitForExpectations(timeout: 1)

      let expectedPeer = TestPeer(
         id: id,
         displayName: changedDisplayName,
         bonjourService: service2
      )
      let expectedState = PeersState(availablePeers: [expectedPeer])
      XCTAssertEqual(state, expectedState)
   }
}
