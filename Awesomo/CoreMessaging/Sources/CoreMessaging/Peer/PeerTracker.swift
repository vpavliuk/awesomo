//
//  PeerTracker.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 16.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Combine

#warning("Try to remove 'ConcretePeer.ID == String' constraint below")
final class PeerTracker<ConcretePeer: Peer> where ConcretePeer.ID == String {

   public typealias State = PeersState<ConcretePeer>

   public init(localPeerId: ConcretePeer.ID, state: State) {
      self.localPeerId = localPeerId
      self.state = state
   }

   let localPeerId: ConcretePeer.ID
   let state: State

   public func trackPeers<
      ServiceEvent: AvailabilityEvent,
      ServiceEventPublisher: Publisher
   >(
      publisher: ServiceEventPublisher
   ) where
         ServiceEvent.Object == ConcretePeer.Service,
         ServiceEventPublisher.Output == Set<ServiceEvent>,
         ServiceEventPublisher.Failure == Never {

      let peerEventsPublisher = publisher
            .map { $0.compactMap(self.convertServiceEventToPeerEvent) }

      subscription = peerEventsPublisher.sink{ peerEvents in
         // Filter out local peer
         let filteredEvents = peerEvents.filter{$0.object.id != self.localPeerId}

         let availableIds = self.state.availablePeers.map{$0.id}
         let lostIds = self.state.lostPeers.map{$0.id}

         for event in filteredEvents {
            let peer = event.object

            switch event.type {
            case .found:
               assert(!availableIds.contains(peer.id))
               self.state.availablePeers.append(peer)
               self.state.lostPeers.removeAll{$0.id == peer.id}

            case .lost:
               #warning("Investigate why this assertion fails")
               assert(availableIds.contains(peer.id))
               assert(!lostIds.contains(peer.id))
               self.state.availablePeers.removeAll{$0.id == peer.id}
               self.state.lostPeers.append(peer)
            }
         }
      }
   }

   private func convertServiceEventToPeerEvent<
      ServiceEvent: AvailabilityEvent
   >(
      event: ServiceEvent
   ) -> PeerAvailabilityEvent<ConcretePeer>? where
         ServiceEvent.Object == ConcretePeer.Service {

      let serviceName: String = event.object.name
      let serviceNameComposer = BonjourNameComposer<ConcretePeer>()
      guard let (peerId, displayName) = try? serviceNameComposer.components(
         fromName: serviceName
      ) else { return nil }

      let peer = ConcretePeer(
         id: peerId,
         displayName: displayName,
         bonjourService: event.object
      )
      return PeerAvailabilityEvent(type: event.type, object: peer)
   }

   private var subscription: AnyCancellable?
}
