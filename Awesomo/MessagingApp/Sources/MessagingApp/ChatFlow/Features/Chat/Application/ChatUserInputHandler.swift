//
//  ChatUserInputHandler.swift
//
//
//  Created by Vova on 19.01.2024.
//

import Domain

struct ChatUserInputHandler: InputEventHandler {
   init(coreMessenger: CoreMessenger, domainStore: DomainStore<CoreMessenger.State>) {
      self.coreMessenger = coreMessenger
      self.domainStore = domainStore
   }

   func on(_ event: ChatUserInput) {
      let domainEvent = Self.domainEvent(from: event)
      domainStore.state = coreMessenger.add(domainEvent)
   }

   private static func domainEvent(from userInput: ChatUserInput) -> Domain.InputEvent {
      return switch userInput {
      case .didInvitePeer(let peerID):
         Domain.InputEvent.userDidInvitePeer(peerID)
      case .didAcceptInvitation(let peerID):
         Domain.InputEvent.userDidAcceptPeersInvitation(peerID)
      default:
         Domain.InputEvent.initial
      }
   }

   private let coreMessenger: CoreMessenger
   private let domainStore: DomainStore<CoreMessenger.State>
}
