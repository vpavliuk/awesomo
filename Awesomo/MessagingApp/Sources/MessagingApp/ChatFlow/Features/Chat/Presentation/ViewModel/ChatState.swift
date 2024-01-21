//
//  ChatState.swift
//
//
//  Created by Vova on 17.01.2024.
//

import Domain
import Foundation

enum ChatState {
   case loading
   case friend([ChatMessageDisplayModel])
   case peerWasInvited
   case peerInvitedUs
   case strangerPeer(StrangerPeerDisplayModel)
   case missingPeer
}

extension ChatState: DomainDerivable {
   static func fromDomainState(_ domainState: Peer.Snapshot?) -> Self {
      guard let domainState else {
         return .missingPeer
      }
      switch domainState.relation {
      case .friend:
         let displayModels = messageDisplayModels(from: domainState)
         return .friend(displayModels)

      case .stranger:
         return .strangerPeer(StrangerPeerDisplayModel(inviteButtonTitle: "Invite \(domainState.name)"))

      default:
         return .friend([])
      }
   }

   private static func messageDisplayModels(from peer: Peer.Snapshot) -> [ChatMessageDisplayModel] {
      let incomingDisplayModels = peer
         .incomingMessages
         .map(ChatMessageDisplayModel.init)
      let outgoingDisplayModels = peer
         .outgoingMessages
         .map(ChatMessageDisplayModel.init)
      return (incomingDisplayModels + outgoingDisplayModels)
         .sorted(by: \.timestamp)
   }
}

struct ChatMessageDisplayModel: Hashable {
   enum HorizontalAlignment {
      case leading, trailing
   }
   let alignment: HorizontalAlignment
   let content: MessageContent
   let timestamp: String
}

extension ChatMessageDisplayModel {

   init(incomingMessage: IncomingChatMessage) {
      alignment = .leading
      content = incomingMessage.content
      timestamp = incomingMessage.timestamp.formatted()
   }

   init(outgoingMessage: OutgoingChatMessage.Snapshot) {
      alignment = .trailing
      content = outgoingMessage.content
      timestamp = outgoingMessage.timestamp.formatted()
   }
}

struct StrangerPeerDisplayModel: Hashable {
   let inviteButtonTitle: String
}
