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
         relation: .invitationInitiated,
         name: peerName,
         networkAddress: networkAddress,
         incomingMessages: [],
         outgoingMessages: []
      )
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])
      let invitation: DomainInput = .userDidInvitePeer(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, invitation)

      // Assert
      XCTAssertEqual(state, [expectedPeer])
   }

   func testInvitationSuccessfullySent() {
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
      let invitation: DomainInput = .userDidInvitePeer(peerID)
      let invitationSendSuccess: DomainInput = .invitationForPeerWasSentOverNetwork(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, invitation, invitationSendSuccess)

      // Assert
      XCTAssertEqual(state, [expectedPeer])
   }

   func testFailedToSendInvitation() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let expectedPeer = Peer.Snapshot(
         peerID: peerID,
         status: .online,
         relation: .stranger,
         name: peerName,
         networkAddress: networkAddress,
         incomingMessages: [],
         outgoingMessages: []
      )
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])
      let invitation: DomainInput = .userDidInvitePeer(peerID)
      let invitationSendFailure: DomainInput = .failedToSendInvitationOverNetwork(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, invitation, invitationSendFailure)

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
      let invitation: DomainInput = .userDidInvitePeer(peerID)
      let invitationSendSuccess: DomainInput = .invitationForPeerWasSentOverNetwork(peerID)
      let confirmation: DomainInput = .peerAcceptedInvitation(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, invitation, invitationSendSuccess, confirmation)

      // Assert
      XCTAssertEqual(state, [
         .makeOnlineFriend(id: peerID, name: peerName, address: networkAddress)
      ])
   }

   func testPeerDeclinedInvitation() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let expectedPeer = Peer.Snapshot(
         peerID: peerID,
         status: .online,
         relation: .declinedInvitation,
         name: peerName,
         networkAddress: networkAddress,
         incomingMessages: [],
         outgoingMessages: []
      )
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])
      let invitation: DomainInput = .userDidInvitePeer(peerID)
      let invitationSendSuccess: DomainInput = .invitationForPeerWasSentOverNetwork(peerID)
      let rejection: DomainInput = .peerDeclinedInvitation(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, invitation, invitationSendSuccess, rejection)

      // Assert
      XCTAssertEqual(state, [expectedPeer])
   }

   func testFriendPeerWentOffline() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: DomainInput = .peersDidAppear([peerID: emergence])
      let invitation: DomainInput = .userDidInvitePeer(peerID)
      let invitationSendSuccess: DomainInput = .invitationForPeerWasSentOverNetwork(peerID)
      let confirmation: DomainInput = .peerAcceptedInvitation(peerID)
      let disappearEvent: DomainInput = .peersDidDisappear([peerID])

      // Act
      let state = sut.add(
         .initial,
         emergenceEvent,
         invitation,
         invitationSendSuccess,
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
      let invitation: DomainInput = .userDidInvitePeer(peerID)
      let invitationSendSuccess: DomainInput = .invitationForPeerWasSentOverNetwork(peerID)
      let confirmation: DomainInput = .peerAcceptedInvitation(peerID)
      let disappearEvent: DomainInput = .peersDidDisappear([peerID])
      let emergenceWithChangedName = PeerEmergence(peerName: changedName, peerAddress: networkAddress)
      let secondEmergenceEvent: DomainInput = .peersDidAppear([peerID: emergenceWithChangedName])

      // Act
      let state = sut.add(
         .initial,
         firstEmergenceEvent,
         invitation,
         invitationSendSuccess,
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
