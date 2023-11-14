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

   typealias PeerID = Peer<String>.ID

   private func peerEventFromServiceEvent(_ serviceEvent: NetServiceAvailabilityEvent)
         -> OutputForApp {

      let emergences = serviceEvent.services.map(peerEmergenceFromNetService)
      switch serviceEvent.change {
      case .found:
         let emergencesByID = Dictionary(uniqueKeysWithValues: emergences)
         return OutputForApp(event: .peersDidAppear(emergencesByID))
      case .lost:
         let peerIDs = Set(emergences.map { $0.id })
         return OutputForApp(event: .peersDidDisappear(peerIDs))
      }
   }

   private func peerEmergenceFromNetService(_ service: NetService)
         -> (id: PeerID, emergence: PeerEmergence<String>) {

      let attributes = bonjourNameComposer
         .peerAttributesFromServiceName(service.name)
      let emergence = PeerEmergence(
         peerName: attributes.peerName,
         peerAddress: service.name
      )
      return (id: attributes.id, emergence: emergence)
   }

   private let inputInternal: PublishingSubscriber<NetServiceAvailabilityEvent, Never>
   public var input: some Subscriber<NetServiceAvailabilityEvent, Never> { inputInternal }

   public typealias OutputForApp = PeerAvailabilityEvent<String>
   public lazy var output: some Publisher<OutputForApp, Never> = outputInternal.publisher
   private let outputInternal: PublishingSubscriber<OutputForApp, Never>

   private let bonjourNameComposer: BonjourNameComposer
}
