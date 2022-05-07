import Utils
import Domain
import Combine

public struct MessagingApp<NetworkAddress, ContentNetworkRepresentation> {
   public init() {
      peerDiscoveryInterfaceInternal = PublishingSubscriber()
      peerDiscoveryInterface = AnySubscriber(peerDiscoveryInterfaceInternal)

      transportInterfaceInternal = PassthroughTwoWayInterface()
      transportInterface = transportInterfaceInternal.eraseToAny()
   }

   public typealias PeerDiscoveryInput = PeerAvailabilityEvent<NetworkAddress>
   public let peerDiscoveryInterface: AnySubscriber<PeerDiscoveryInput, Never>
   private let peerDiscoveryInterfaceInternal: PublishingSubscriber<PeerDiscoveryInput, Never>

   public typealias TransportInterfaceInput = InputFromTransport<NetworkAddress, ContentNetworkRepresentation>
   public typealias TransportInterfaceOutput = TransportSendRequest<NetworkAddress, ContentNetworkRepresentation>
   public let transportInterface: AnyTwoWayInterface<TransportInterfaceInput, TransportInterfaceOutput>
   private let transportInterfaceInternal: PassthroughTwoWayInterface<TransportInterfaceInput, TransportInterfaceOutput>
}
