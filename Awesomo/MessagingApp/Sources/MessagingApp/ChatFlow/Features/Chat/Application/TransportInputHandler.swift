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
      return switch transportEvent {
      case .invitationForPeerWasSentOverNetwork(let peerID):
         .invitationForPeerWasSentOverNetwork(peerID)

      case .failedToSendInvitationOverNetwork(let peerID):
         .failedToSendInvitationOverNetwork(peerID)

      case .peerInvitedUs(let peerID):
         .peerInvitedUs(peerID)

      case .peerAcceptedInvitation(let peerID):
         .peerAcceptedInvitation(peerID)

      case .messageWasSentOverNetwork(let messageID):
         .failedToSendMessageOverNetwork(messageID)

      case .failedToSendMessageOverNetwork(let messageID):
         .failedToSendMessageOverNetwork(messageID)

      case .messageArrived(let senderID, let message):
         .messageArrived(senderID, message)

      case .invitationAcceptanceWasSentOverNetwork(let peerID):
         .invitationAcceptanceForPeerWasSentOverNetwork(peerID)

      case .failedToSendInvitationAcceptance(let peerID):
         .failedToSendInvitationAcceptanceOverNetwork(peerID)
      }
   }

   private let coreMessenger: CoreMessenger
   private let domainStore: DomainStore<CoreMessenger.State>
}
