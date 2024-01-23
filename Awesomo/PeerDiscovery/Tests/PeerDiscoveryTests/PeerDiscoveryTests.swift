@testable
import PeerDiscovery
import XCTest
import Combine
import BonjourBrowser
import Domain
import MessagingApp
import TestUtils

final class PeerDiscoveryTests: XCTestCase {

   var sut: PeerDiscovery!
   var inputFromServiceBrowser: PassthroughSubject<NetServiceAvailabilityEvent, Never>!
   var bonjourNameComposer: BonjourNameComposerMock!

   override func setUp() {
      bonjourNameComposer = BonjourNameComposerMock()
      sut = PeerDiscovery(bonjourNameComposer: bonjourNameComposer)
      sut.wireUp()
      inputFromServiceBrowser = PassthroughSubject()
      inputFromServiceBrowser.subscribe(sut.input)
   }

   func testOneServiceFound() {
      // Arrange
      let peerName = "peer_1"
      let peerIDUUID = UUID()
      let peerIDString = peerIDUUID.uuidString
      let foundService = makeNetService(
         peerIdString: peerIDString,
         peerName: peerName
      )
      let networkAddress = foundService.name
      let serviceBrowserEvent = NetServiceAvailabilityEvent(
         availabilityChange: .found,
         services: [foundService]
      )
      let expectedPeerId = Peer.ID(value: peerIDUUID.uuidString)
      let expectedPeer = PeerEmergence(
         peerName: peerName,
         peerAddress: NetworkAddress(value: networkAddress)
      )
      let expectedOutput: PeerAvailabilityEvent = .peersDidAppear([expectedPeerId: expectedPeer])

      // Act
      inputFromServiceBrowser.send(serviceBrowserEvent)
      inputFromServiceBrowser.send(completion: .finished)

      // Assert
      expectLater(sut.output, output: [expectedOutput])
   }

   func testOneServiceLost() {
      // Arrange
      let peerName = "peer_1"
      let peerIDUUID = UUID()
      let peerIDString = peerIDUUID.uuidString
      let foundService = makeNetService(
         peerIdString: peerIDString,
         peerName: peerName
      )

      let serviceBrowserEvent = NetServiceAvailabilityEvent(
         availabilityChange: .lost,
         services: [foundService]
      )
      let expectedPeerId = Peer.ID(value: peerIDUUID.uuidString)
      let expectedOutput: PeerAvailabilityEvent = .peersDidDisappear([expectedPeerId])

      // Act
      inputFromServiceBrowser.send(serviceBrowserEvent)
      inputFromServiceBrowser.send(completion: .finished)

      // Assert
      expectLater(sut.output, output: [expectedOutput])
   }

   private func makeNetService(peerIdString: String, peerName: String)
         -> NetService {

      let serviceName = bonjourNameComposer.serviceName(
         fromIdString: peerIdString,
         peerName: peerName
      )
      return NetService(
         domain: bonjourDomain,
         type: bonjourServiceType,
         name: serviceName
      )
   }

   private let bonjourServiceType = "test_type"
   private let bonjourDomain = "local"
}
