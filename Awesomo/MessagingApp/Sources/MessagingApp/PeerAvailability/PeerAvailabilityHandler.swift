//
//  PeerAvailabilityHandler.swift
//
//
//  Created by Vova on 02.12.2023.
//

import Domain

public struct PeerAvailabilityHandler: InputHandler {

   init(coreMessenger: CoreMessenger, completion: @escaping (CoreMessenger.State) -> Void) {
      self.coreMessenger = coreMessenger
      self.completion = completion
   }

   public func on(_ event: PeerAvailabilityEvent) {
      let domainEvent = Domain.InputEvent(peerAvailabilityEvent: event)
      let state = coreMessenger.add(domainEvent)
      completion(state)
   }

   private let coreMessenger: CoreMessenger
   private let completion: (CoreMessenger.State) -> Void
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
