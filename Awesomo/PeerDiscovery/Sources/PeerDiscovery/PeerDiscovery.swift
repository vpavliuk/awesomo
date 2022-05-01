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
         .subscribe(outputInternal)
   }

   typealias Peer = OutputForApp.Peer
   private func peerEventFromServiceEvent(
      _ serviceEvent: NetServiceAvailabilityEvent
   ) -> OutputForApp {
      OutputForApp(peers: [Peer(displayName: "", networkAddress: "")], availabilityChange: .found)
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
