import Foundation
import Combine
import Utils
import MessagingApp

public struct PeerDiscovery {
   public init(bonjourNameComposer: BonjourNameComposer) {
      self.bonjourNameComposer = bonjourNameComposer

      inputInternal = PublishingSubscriber()
      input = AnySubscriber(inputInternal)

      outputInternal = PublishingSubscriber<OutputForApp, Never>()
      output = outputInternal.publisher.eraseToAnyPublisher()
   }

   public func wireUp() {
      inputInternal.publisher
         .map(peerEventFromServiceEvent)
         .delay(for: .zero, scheduler: RunLoop.main, options: .none)
         .subscribe(outputInternal)
   }

   typealias Peer = OutputForApp.Peer
   private func peerEventFromServiceEvent(
      _ serviceEvent: NetServiceAvailabilityEvent
   ) -> OutputForApp {
      let peers = serviceEvent.services.map(peerFromNetService)
      let change: OutputForApp.AvailabilityChange =
            (serviceEvent.eventType == .found) ? .found : .lost
      return OutputForApp(peers: peers, availabilityChange: change)
   }

   private func peerFromNetService(_ service: NetService) -> Peer {
      let attributes = bonjourNameComposer
         .peerAttributesFromServiceName(service.name)
      return Peer(
         id: attributes.id,
         displayName: attributes.displayName,
         networkAddress: service.name
      )
   }

   public let input: AnySubscriber<NetServiceAvailabilityEvent, Never>
   private let inputInternal: PublishingSubscriber<NetServiceAvailabilityEvent, Never>

   public typealias OutputForApp = PeerAvailabilityEvent<String>
   public let output: AnyPublisher<OutputForApp, Never>
   private let outputInternal: PublishingSubscriber<OutputForApp, Never>

   private let bonjourNameComposer: BonjourNameComposer
}

#warning("This belongs to bonjour browser")
public struct NetServiceAvailabilityEvent {
   #warning("Needs to be internal")
   public init(eventType: NetServiceAvailabilityEvent.EventType, services: [NetService]) {
      self.eventType = eventType
      self.services = services
   }

   public enum EventType { case found, lost }
   public let eventType: EventType
   public let services: [NetService]
}
