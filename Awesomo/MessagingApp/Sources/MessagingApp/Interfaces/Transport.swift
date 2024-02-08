//
//  Transport.swift
//  Messaging App
//
//  Created by Volodymyr Pavliuk on 30.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Domain

public enum NetworkMessage<ContentNetworkRepresentation> {
   case chatRequest
   case chatMessage//(ChatMessage<ContentNetworkRepresentation>)
}

// MARK: - Input
public enum InputFromTransport: InputEvent {
   case invitationForPeerWasSentOverNetwork(Peer.ID)
   case failedToSendInvitationOverNetwork(Peer.ID)
   case peerAcceptedInvitation(Peer.ID)
   case peerInvitedUs(Peer.ID)
   case messageWasSentOverNetwork(OutgoingChatMessage.ID)
   case failedToSendMessageOverNetwork(OutgoingChatMessage.ID)
   case messageArrived(Peer.ID, IncomingChatMessage)
   case invitationAcceptanceWasSentOverNetwork(Peer.ID)
   case failedToSendInvitationAcceptance(Peer.ID)
}
