import XCTest
import Combine
import Domain

final class CoreMessengerTest: XCTestCase {
   private var sut: CoreMessenger!

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
      let networkAddress = NetworkAddress(value: "123")
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: InputEvent = .peersDidAppear([peerID: emergence])

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
      let networkAddress = NetworkAddress(value: "123")
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: InputEvent = .peersDidAppear([peerID: emergence])
      let disappearEvent: InputEvent = .peersDidDisappear([peerID])

      // Act
      let peersAfterDisappear = sut.add(.initial, emergenceEvent, disappearEvent)

      // Assert
      XCTAssert(peersAfterDisappear.isEmpty)
   }

   func testInvitePeer() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = NetworkAddress(value: "123")
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
      let emergenceEvent: InputEvent = .peersDidAppear([peerID: emergence])
      let invitation: InputEvent = .userDidInvitePeer(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, invitation)

      // Assert
      XCTAssertEqual(state, [expectedPeer])
   }

   func testInvitationSuccessfullySent() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = NetworkAddress(value: "123")
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
      let emergenceEvent: InputEvent = .peersDidAppear([peerID: emergence])
      let invitation: InputEvent = .userDidInvitePeer(peerID)
      let invitationSendSuccess: InputEvent = .invitationForPeerWasSentOverNetwork(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, invitation, invitationSendSuccess)

      // Assert
      XCTAssertEqual(state, [expectedPeer])
   }

   func testFailedToSendInvitation() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = NetworkAddress(value: "123")
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
      let emergenceEvent: InputEvent = .peersDidAppear([peerID: emergence])
      let invitation: InputEvent = .userDidInvitePeer(peerID)
      let invitationSendFailure: InputEvent = .failedToSendInvitationOverNetwork(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, invitation, invitationSendFailure)

      // Assert
      XCTAssertEqual(state, [expectedPeer])
   }

   func testPeerAcceptedInvitation() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = NetworkAddress(value: "123")
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: InputEvent = .peersDidAppear([peerID: emergence])
      let invitation: InputEvent = .userDidInvitePeer(peerID)
      let invitationSendSuccess: InputEvent = .invitationForPeerWasSentOverNetwork(peerID)
      let confirmation: InputEvent = .peerAcceptedInvitation(peerID)

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
      let networkAddress = NetworkAddress(value: "123")
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
      let emergenceEvent: InputEvent = .peersDidAppear([peerID: emergence])
      let invitation: InputEvent = .userDidInvitePeer(peerID)
      let invitationSendSuccess: InputEvent = .invitationForPeerWasSentOverNetwork(peerID)
      let rejection: InputEvent = .peerDeclinedInvitation(peerID)

      // Act
      let state = sut.add(.initial, emergenceEvent, invitation, invitationSendSuccess, rejection)

      // Assert
      XCTAssertEqual(state, [expectedPeer])
   }

   func testFriendPeerWentOffline() {
      // Arrange
      let peerID = Peer.ID(value: "1")
      let peerName = "Unknown peer"
      let networkAddress = NetworkAddress(value: "123")
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let emergenceEvent: InputEvent = .peersDidAppear([peerID: emergence])
      let invitation: InputEvent = .userDidInvitePeer(peerID)
      let invitationSendSuccess: InputEvent = .invitationForPeerWasSentOverNetwork(peerID)
      let confirmation: InputEvent = .peerAcceptedInvitation(peerID)
      let disappearEvent: InputEvent = .peersDidDisappear([peerID])

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
      let networkAddress = NetworkAddress(value: "123")
      let emergence = PeerEmergence(peerName: peerName, peerAddress: networkAddress)
      let firstEmergenceEvent: InputEvent = .peersDidAppear([peerID: emergence])
      let invitation: InputEvent = .userDidInvitePeer(peerID)
      let invitationSendSuccess: InputEvent = .invitationForPeerWasSentOverNetwork(peerID)
      let confirmation: InputEvent = .peerAcceptedInvitation(peerID)
      let disappearEvent: InputEvent = .peersDidDisappear([peerID])
      let emergenceWithChangedName = PeerEmergence(peerName: changedName, peerAddress: networkAddress)
      let secondEmergenceEvent: InputEvent = .peersDidAppear([peerID: emergenceWithChangedName])

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
