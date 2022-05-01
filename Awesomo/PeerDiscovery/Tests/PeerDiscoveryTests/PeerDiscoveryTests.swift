import XCTest
import Combine
import PeerDiscovery
import MessagingApp
import TestUtils

final class PeerDiscoveryTests: XCTestCase {
   typealias PeerEvent = PeerAvailabilityEvent<String>
   typealias Peer = PeerEvent.Peer

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
         eventType: .found,
         services: [foundService]
      )
      let expectedPeerId = Peer.ID(value: peerIDUUID)
      let expectedPeer = Peer(
         id: expectedPeerId,
         displayName: peerName,
         networkAddress: networkAddress
      )
      let expectedOutput = PeerEvent(
         peers: [expectedPeer],
         availabilityChange: .found
      )

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
         displayName: peerName
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
