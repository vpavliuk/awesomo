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
   case didSendMessage(MessageContent)
}

extension ChatUserInput: UserInput {}
