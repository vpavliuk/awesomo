//
//  InputEvent.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

public enum InputEvent {
   case initial
   case peersDidAppear([Peer.ID: PeerEmergence])
   case peersDidDisappear(Set<Peer.ID>)
   case userDidInvitePeer(Peer.ID)
   case invitationForPeerWasSentOverNetwork(Peer.ID)
   case failedToSendInvitationOverNetwork(Peer.ID)
   case userDidAcceptPeersInvitation(Peer.ID)
//   case peerDidInvite(ConcretePeer.ID)
   case peerAcceptedInvitation(Peer.ID)
   case messageArrived(Peer.ID, IncomingChatMessage)
   case userAttemptedSendMessage(Peer.ID, OutgoingChatMessage)
   case outgoingMessageWasSentOverNetwork(OutgoingChatMessage.ID)
}
