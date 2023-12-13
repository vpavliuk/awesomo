import Foundation
import Combine
import Utils
import Domain
import MessagingApp
import BonjourBrowser

public struct PeerDiscovery {
   public init(bonjourNameComposer: BonjourNameComposer = BonjourNameComposerImpl()) {
      self.bonjourNameComposer = bonjourNameComposer
      self.inputInternal = PublishingSubscriber()
      self.outputInternal = PublishingSubscriber()
   }

   public func wireUp() {
      inputInternal.publisher
         .map(peerEventFromServiceEvent)
         .delay(for: .zero, scheduler: RunLoop.main, options: .none)
         .subscribe(outputInternal)
   }

   private func peerEventFromServiceEvent(_ serviceEvent: NetServiceAvailabilityEvent)
         -> PeerAvailabilityEvent {

      let emergences = serviceEvent.services.map(peerEmergenceFromNetService)
      switch serviceEvent.change {
      case .found:
         let emergencesByID = Dictionary(uniqueKeysWithValues: emergences)
         return .peersDidAppear(emergencesByID)
      case .lost:
         let peerIDs = Set(emergences.map(\.id))
         return .peersDidDisappear(peerIDs)
      }
   }

   private func peerEmergenceFromNetService(_ service: NetService)
   -> (id: Peer.ID, emergence: PeerEmergence) {

      let attributes = bonjourNameComposer
         .peerAttributesFromServiceName(service.name)
      let emergence = PeerEmergence(
         peerName: attributes.peerName,
         peerAddress: NetworkAddress(value: service.name)
      )
      return (id: attributes.id, emergence: emergence)
   }

   private let inputInternal: PublishingSubscriber<NetServiceAvailabilityEvent, Never>
   public var input: some Subscriber<NetServiceAvailabilityEvent, Never> { inputInternal }

   public var output: some Publisher<PeerAvailabilityEvent, Never> { outputInternal.publisher }
   private let outputInternal: PublishingSubscriber<PeerAvailabilityEvent, Never>

   private let bonjourNameComposer: BonjourNameComposer
}
