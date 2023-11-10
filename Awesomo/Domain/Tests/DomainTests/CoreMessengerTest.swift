import XCTest
import Combine
@testable import Domain

final class CoreMessengerTest: XCTestCase {
   private typealias DomainInput = InputEvent<String>
   private typealias Peer = Domain.Peer<String>
   private var sut: CoreMessenger<String>!
   private var eventPublisher: PassthroughSubject<DomainInput, Never>!

   override func setUp() {
      eventPublisher = PassthroughSubject()
      sut = CoreMessenger()
      eventPublisher.subscribe(sut.inputInterface)
   }

   override func tearDown() {
      weak var weakSut = sut
      sut = nil
      XCTAssertNil(weakSut)
   }

   func testInitial() {
      XCTAssert(sut.allPeers.isEmpty)
   }

   func testStrangerPeerEmerged() {
      // Arrange
      let peerId = "1"
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let expectedPeer = Peer(
         id: Peer.ID(value: peerId),
         status: .online,
         relation: .stranger,
         name: peerName,
         networkAddress: networkAddress
      )
      let emergence = PeerEmergence(
         peerID: Peer.ID(value: peerId),
         peerName: peerName,
         peerAddress: networkAddress
      )
      let event = DomainInput.peersDidAppear([emergence])

      // Act
      eventPublisher.send(event)

      // Assert
      XCTAssertEqual(sut.allPeers, [expectedPeer])
   }

   func testStrangerPeerDidDisappear() throws {
      // Arrange
      let peerId = "1"
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let offlineStrangerPeer = Peer(
         id: Peer.ID(value: peerId),
         status: .offline,
         relation: .stranger,
         name: peerName,
         networkAddress: networkAddress
      )
      let emergence = PeerEmergence(
         peerID: Peer.ID(value: peerId),
         peerName: peerName,
         peerAddress: networkAddress
      )
      let emergenceEvent = DomainInput.peersDidAppear([emergence])
      let disappearEvent = DomainInput.peersDidDisappear([Peer.ID(value: peerId)])

      // Act
      eventPublisher.send(emergenceEvent)
      let actualPeer = try XCTUnwrap(sut.allPeers.last)
      eventPublisher.send(disappearEvent)

      // Assert
      XCTAssertEqual(actualPeer, offlineStrangerPeer)
      XCTAssert(sut.allPeers.isEmpty)
   }

   func testFriendPeerEmerged() {
      // Arrange
      let peerId = "1"
      let peerName = "Unknown peer"
      let networkAddress = "123"
      let expectedPeer = Peer(
         id: Peer.ID(value: peerId),
         status: .online,
         relation: .stranger,
         name: peerName,
         networkAddress: networkAddress
      )
      let emergence = PeerEmergence(
         peerID: Peer.ID(value: peerId),
         peerName: peerName,
         peerAddress: networkAddress
      )
      let event = DomainInput.peersDidAppear([emergence])
      eventPublisher.send(event)
   }
}
