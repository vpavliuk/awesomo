//
//  PeerAvailabilityHandler.swift
//
//
//  Created by Vova on 02.12.2023.
//

import Domain

public struct PeerAvailabilityHandler: InputHandler {

   public func on(_ event: PeerAvailabilityEvent) {
      let domainEvent = Domain.InputEvent(peerAvailabilityEvent: event)
      //coreMessenger.add(domainEvent)
   }
}

private extension Domain.InputEvent {
   init(peerAvailabilityEvent: PeerAvailabilityEvent) {
      switch peerAvailabilityEvent {
      case .peersDidAppear(let emergences):
         self = .peersDidAppear(emergences)
      case .peersDidDisappear(let peerIDs):
         self = .peersDidDisappear(peerIDs)
      }
   }
}
