//
//  InputEvent.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

#warning("Revise NetworkAddress")
public enum InputEvent<NetworkAddress: Hashable> {
   public typealias PeerID = Peer<NetworkAddress>.ID
   case peersDidAppear([PeerID: PeerEmergence<NetworkAddress>])
   case peersDidDisappear(Set<PeerID>)
   case userDidInvitePeer(PeerID)
//   case peerDidInvite(ConcretePeer.ID)
//   case peerDidAcceptInvitation(ConcretePeer.ID)
   case messageArrived(PeerID, IncomingChatMessage)
   case userAttemptedSendMessage(PeerID, OutgoingChatMessage)
   case outgoingMessageWasSentOverNetwork(OutgoingChatMessage.ID)
}
