import Utils
import Domain
import Combine

public final class MessagingApp<NetworkAddress: Equatable, ContentNetworkRepresentation> {
   public init() {
      peerDiscoveryInterfaceInternal = PublishingSubscriber()
      peerDiscoveryInterface = AnySubscriber(peerDiscoveryInterfaceInternal)

      transportInterfaceInternal = PassthroughTwoWayInterface()
      transportInterface = transportInterfaceInternal.eraseToAny()
   }

   public func wireUp() {
      wireUpPeerDiscovery()
   }

   private func wireUpPeerDiscovery() {
      let s = peerDiscoveryInterfaceInternal.publisher.sink { [weak self] availabilityEvent in
         guard let self = self else { return }
         let oldActivePeers = self.activePeers
         self.updateActivePeers(event: availabilityEvent)
         if self.activeScreen == .conversationList
               && oldActivePeers != self.activePeers {

         }
      }
      subscriptions.insert(s)
   }

   public typealias PeerDiscoveryInput = PeerAvailabilityEvent<NetworkAddress>
   public let peerDiscoveryInterface: AnySubscriber<PeerDiscoveryInput, Never>
   private let peerDiscoveryInterfaceInternal: PublishingSubscriber<PeerDiscoveryInput, Never>

   public typealias TransportInterfaceInput = InputFromTransport<NetworkAddress, ContentNetworkRepresentation>
   public typealias TransportInterfaceOutput = TransportSendRequest<NetworkAddress, ContentNetworkRepresentation>
   public let transportInterface: AnyTwoWayInterface<TransportInterfaceInput, TransportInterfaceOutput>
   private let transportInterfaceInternal: PassthroughTwoWayInterface<TransportInterfaceInput, TransportInterfaceOutput>

   private typealias Peer = Domain.Peer<NetworkAddress>
   private enum ActiveScreen: Equatable { case conversationList, selectedConversation(Peer.ID) }
   private var activeScreen: ActiveScreen = .conversationList
   private var activePeers: [Peer] = []



   private var subscriptions = Set<AnyCancellable>()

   private func updateActivePeers(event: PeerAvailabilityEvent<NetworkAddress>) {
      let eventPeerIds = event.peers.map(\.id)
      var updatedActivePeers = activePeers
      updatedActivePeers.removeAll { eventPeerIds.contains($0.id) }
      if event.change == .found {
         updatedActivePeers.append(contentsOf: event.peers)
      }
      activePeers = updatedActivePeers
   }
}
