import Utils
import Domain
import Combine

public final class MessagingApp<NetworkAddress: Hashable, ContentNetworkRepresentation> {
   public init() {
      peerDiscoveryInterfaceInternal = PublishingSubscriber()

      //transportInterfaceInternal = PassthroughTwoWayInterface()
      //transportInterface = transportInterfaceInternal.eraseToAny()
   }

   public func wireUp() {
      wireUpPeerDiscovery()
   }

   private func wireUpPeerDiscovery() {
      peerDiscoveryInterfaceInternal
         .publisher
         .map(domainEventFromPeerDiscoveryEvent)
   }

   private func domainEventFromPeerDiscoveryEvent(_ event: PeerDiscoveryInput) -> Domain.InputEvent<NetworkAddress> {
      return switch event.event {
      case .peersDidAppear(let emergences):
         .peersDidAppear(emergences)
      case .peersDidDisappear(let peerIDs):
         .peersDidDisappear(peerIDs)
      }
   }

   public lazy var input: some Subscriber<InputEvent, Never> = inputInternal
   private let inputInternal = PublishingSubscriber<any InputEvent, Never>()

   public typealias PeerDiscoveryInput = PeerAvailabilityEvent<NetworkAddress>
   public var peerDiscoveryInterface: some Subscriber<PeerDiscoveryInput, Never> { peerDiscoveryInterfaceInternal }
   private let peerDiscoveryInterfaceInternal: PublishingSubscriber<PeerDiscoveryInput, Never>

   private let coreMessenger = CoreMessenger<NetworkAddress>()

   private var subscriptions = Set<AnyCancellable>()


   private func handleUserInput(_ input: UserInput<NetworkAddress>) {
      switch input.event {
      default:
         break
      }
   }

   public typealias ConcretePeer = Peer<NetworkAddress>
   @Published
   public var peers: [ConcretePeer] = []

}
