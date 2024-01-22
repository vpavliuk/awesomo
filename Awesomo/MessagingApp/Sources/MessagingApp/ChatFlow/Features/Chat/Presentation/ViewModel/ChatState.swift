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
   case peerInvitedUs(Peer.ID, PeerInvitedUsDisplayModel)
   case strangerPeer(Peer.ID, StrangerPeerDisplayModel)
   case missingPeer(String)
}

extension ChatState: DomainDerivable {
   static func fromDomainState(_ domainState: Peer.Snapshot?) -> Self {
      guard let domainState else {
         return .missingPeer("The user is no longer available")
      }
      return fromPeer(domainState)
   }

      private static func fromPeer(_ peer: Peer.Snapshot) -> Self {
         return switch peer.relation {
         case .friend:
            ChatState.friend(messageDisplayModels(from: peer))

         case .stranger:
            ChatState.strangerPeer(
               peer.peerID,
               StrangerPeerDisplayModel(
                  messageTitle: "\(peer.name) is online!",
                  messageDescription: "Invite them to a chat where you can share text, photos, and more.",
                  inviteButtonTitle: "Invite"
               )
            )

         case .didInviteUs:
            ChatState.peerInvitedUs(
               peer.peerID,
               PeerInvitedUsDisplayModel(
                  messageTitle: "\(peer.name) wants to connect",
                  messageDescription: "\(peer.name) would like to share something with you. Accept their request?",
                  acceptButtonTitle: "Accept"
               )
            )

         default:
            ChatState.friend([])
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
   let messageTitle: String
   let messageDescription: String
   let inviteButtonTitle: String
}
