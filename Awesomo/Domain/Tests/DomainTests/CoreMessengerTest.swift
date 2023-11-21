import XCTest
import Combine
@testable import Domain

final class CoreMessengerTest: XCTestCase {
   private typealias DomainInput = InputEvent<String>
   private typealias Peer = Domain.Peer<String>
   private var sut: CoreMessenger<String>!

   override func setUp() {
      sut = CoreMessenger()
   }

   override func tearDown() {
      weak var weakSut = sut
      sut = nil
      XCTAssertNil(weakSut)
   }

   func testInitial() {
      // Act
      let state = sut.add(.initial)

      // Assert
      XCTAssert(state.isEmpty)
   }

   func testStrangerPeerEmerged() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])

      // Act
      let state = sut.add(.initial, emergenceEvent)

      // Assert
      XCTAssertEqual(state, [
         .makeOnlineStranger(id: peerID, name: peerName, address: networkAddress)
      ])
   }

   func testStrangerPeerDidDisappear() throws {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])
      let disappearEvent: DomainInput = .peersDidDisappear([peerID])

      // Act
      let peersAfterDisappear = sut.add(.initial, emergenceEvent, disappearEvent)

      // Assert
      XCTAssert(peersAfterDisappear.isEmpty)
   }

   func testInvitePeer() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let expectedPeer = Peer.Snapshot(
         peerID: peerID,
         status: .online,
         relation: .wasInvited,
         name: peerName,
         networkAddress: networkAddress,
         incomingMessages: [],
         outgoingMessages: []
      )
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])
      let friendRequest: DomainInput = .userDidInvitePeer(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, friendRequest)

      // Assert
      XCTAssertEqual(state, [expectedPeer])
   }

   func testPeerAcceptedInvitation() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])
      let friendRequest: DomainInput = .userDidInvitePeer(peerID)
      let confirmation: DomainInput = .peerDidAcceptInvitation(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, friendRequest, confirmation)

      // Assert
      XCTAssertEqual(state, [
         .makeOnlineFriend(id: peerID, name: peerName, address: networkAddress)
      ])
   }

   func testFriendPeerDidDisappear() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])
      let friendRequest: DomainInput = .userDidInvitePeer(peerID)
      let confirmation: DomainInput = .peerDidAcceptInvitation(peerID)
      let disappearEvent: DomainInput = .peersDidDisappear([peerID])

      // Act
      let state = sut.add(
         .initial,
         emergenceEvent,
         friendRequest,
         confirmation,
         disappearEvent
      )

      // Assert
      XCTAssertEqual(state, [
         .makeOfflineFriend(id: peerID, name: peerName, address: networkAddress)
      ])
   }

   func testFriendPeerEmergedWithChangedName() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let changedName = "Changed Name"
      let networkAddress = "123"
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let firstEmergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])
      let friendRequest: DomainInput = .userDidInvitePeer(peerID)
      let confirmation: DomainInput = .peerDidAcceptInvitation(peerID)
      let disappearEvent: DomainInput = .peersDidDisappear([peerID])
      let emergenceWithChangedName = PeerEmergence(peerName: changedName, peerAddress: networkAddress)
      let secondEmergenceEvent: DomainInput = .peersDidAppear([peerID: emergenceWithChangedName])

      // Act
      let state = sut.add(
         .initial,
         firstEmergenceEvent,
         friendRequest,
         confirmation,
         disappearEvent,
         secondEmergenceEvent
      )

      // Assert
      XCTAssertEqual(state, [
         .makeOnlineFriend(id: peerID, name: changedName, address: networkAddress)
      ])
   }
}
