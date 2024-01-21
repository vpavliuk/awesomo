//
//  ChatUserInput.swift
//
//
//  Created by Vova on 17.01.2024.
//

import Domain

enum ChatUserInput {
   case didInvitePeer(Peer.ID)
   case didAcceptInvitation(Peer.ID)
   case didDeclineInvitation(Peer.ID)
   case didSendMessage(MessageContent)
}

extension ChatUserInput: UserInput {

}


extension MessageContent: Codable {
   public func encode(to encoder: Encoder) throws {

   }
   
   public init(from decoder: Decoder) throws {
      self.init(contentID: ContentID(value: "Text"))
   }
}
