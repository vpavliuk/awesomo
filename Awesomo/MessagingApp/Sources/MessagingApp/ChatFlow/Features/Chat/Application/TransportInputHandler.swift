//
//  TransportInputHandler.swift
//
//
//  Created by Vova on 30.01.2024.
//

import Domain

struct TransportInputHandler: InputEventHandler {
   init(coreMessenger: CoreMessenger, domainStore: DomainStore<CoreMessenger.State>) {
      self.coreMessenger = coreMessenger
      self.domainStore = domainStore
   }

   func on(_ event: InputFromTransport) {
      let domainEvent = Self.domainEvent(from: event)
      domainStore.state = coreMessenger.add(domainEvent)
   }

   private static func domainEvent(from transportEvent: InputFromTransport) -> Domain.InputEvent {
      switch transportEvent {
      case .invitationForPeerWasSentOverNetwork(let peerID):
         return .invitationForPeerWasSentOverNetwork(peerID)

      case .failedToSendInvitationOverNetwork(let peerID):
         return .failedToSendInvitationOverNetwork(peerID)
      }
   }

   private let coreMessenger: CoreMessenger
   private let domainStore: DomainStore<CoreMessenger.State>
}
