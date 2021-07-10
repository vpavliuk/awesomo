//
//  PeersStateTest.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 22.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import XCTest
@testable import CoreMessaging

final class PeersStateTest: XCTestCase {
   typealias State = PeersState<TestPeer>
   var sut: State!

   override func setUp() {
      super.setUp()

      sut = State()
   }

   func testInitial() {
      XCTAssertTrue(sut.availablePeers.isEmpty)
      XCTAssertTrue(sut.lostPeers.isEmpty)
      XCTAssertTrue(sut.allPeers.isEmpty)
   }

   func testNotEqual1() {
      let notEqual = State(availablePeers: [TestPeer()])
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual2() {
      let notEqual = State(lostPeers: [TestPeer()])
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual3() {
      let notEqual = State(
         availablePeers: [TestPeer(id: "1")],
         lostPeers: [TestPeer(id: "2")]
      )
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual4() {
      let notEqual = State(availablePeers: [TestPeer(id: "1")])
      sut.availablePeers = [TestPeer(id: "2")]
      XCTAssertNotEqual(sut, notEqual)
   }

   func testNotEqual5() {
      let notEqual = State(
         availablePeers: [TestPeer(id: "1")],
         lostPeers: [TestPeer(id: "2")]
      )

      sut.availablePeers = [TestPeer(id: "2")]
      sut.lostPeers = [TestPeer(id: "1")]

      XCTAssertNotEqual(sut, notEqual)
   }

   func testEqualInital() {
      XCTAssertEqual(sut, State())
   }

   func testEqual2() {
      let equal = State(availablePeers: [TestPeer()])
      sut.availablePeers = [TestPeer()]
      XCTAssertEqual(sut, equal)
   }

   func testEqual3() {
      let equal = State(lostPeers: [TestPeer()])
      sut.lostPeers = [TestPeer()]
      XCTAssertEqual(sut, equal)
   }

   func testEqual4() {
      let equal = State(
         availablePeers: [TestPeer(id: "1")],
         lostPeers: [TestPeer(id: "2")]
      )

      sut.availablePeers = [TestPeer(id: "1")]
      sut.lostPeers = [TestPeer(id: "2")]

      XCTAssertEqual(sut, equal)
   }

   func testAllPeers() {
      let peer1 = TestPeer(id: "1")
      let peer2 = TestPeer(id: "2")
      sut.availablePeers = [peer1, peer2]
      XCTAssertEqual(sut.allPeers, [peer1, peer2])
   }

   func testAllPeers2() {
      let peer1 = TestPeer(id: "1")
      let peer2 = TestPeer(id: "2")
      sut.availablePeers = [peer2]
      sut.lostPeers = [peer1]
      XCTAssertEqual(sut.allPeers, [peer2, peer1])
   }

   func testAllPeers3() {
      let peer1 = TestPeer(id: "1")
      let peer2 = TestPeer(id: "2")
      sut.lostPeers = [peer2, peer1]
      XCTAssertEqual(sut.allPeers, [peer2, peer1])
   }
}
