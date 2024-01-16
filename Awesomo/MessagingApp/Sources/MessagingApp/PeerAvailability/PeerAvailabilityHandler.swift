//
//  PeerAvailabilityHandler.swift
//
//
//  Created by Vova on 02.12.2023.
//

import Domain

public struct PeerAvailabilityHandler: InputEventHandler {

   init(coreMessenger: CoreMessenger, domainStore: DomainStore<CoreMessenger.State>) {
      self.coreMessenger = coreMessenger
      self.domainStore = domainStore
   }

   public func on(_ event: PeerAvailabilityEvent) {
      let domainEvent = Domain.InputEvent(peerAvailabilityEvent: event)
      domainStore.state = coreMessenger.add(domainEvent)
   }

   private let coreMessenger: CoreMessenger
   private let domainStore: DomainStore<CoreMessenger.State>
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
