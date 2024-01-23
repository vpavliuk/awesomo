//
//  PeerAvailabilityHandler.swift
//
//
//  Created by Vova on 02.12.2023.
//

import Domain

public struct PeerAvailabilityHandler: InputEventHandler {

   init(
      appUserID: Peer.ID,
      coreMessenger: CoreMessenger,
      domainStore: DomainStore<CoreMessenger.State>
   ) {
      self.appUserID = appUserID
      self.coreMessenger = coreMessenger
      self.domainStore = domainStore
   }

   public func on(_ event: PeerAvailabilityEvent) {
      guard let domainEvent = domainEvent(from: event) else {
         return
      }
      domainStore.state = coreMessenger.add(domainEvent)
   }

   private func domainEvent(from peerAvailabilityEvent: PeerAvailabilityEvent) -> Domain.InputEvent? {
      // Filter out records related to the app user
      switch peerAvailabilityEvent {
      case .peersDidAppear(let emergences):
         let filteredEmergences = emergences.filter { $0.key != appUserID  }
         if filteredEmergences.isEmpty {
            return nil
         }
         return .peersDidAppear(filteredEmergences)

      case .peersDidDisappear(let peerIDs):
         let filteredPeerIDs = peerIDs.filter { $0 != appUserID }
         if filteredPeerIDs.isEmpty {
            return nil
         }
         return .peersDidDisappear(filteredPeerIDs)
      }
   }

   private let appUserID: Peer.ID
   private let coreMessenger: CoreMessenger
   private let domainStore: DomainStore<CoreMessenger.State>
}
