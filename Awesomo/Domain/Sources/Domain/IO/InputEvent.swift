//
//  InputEvent.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

#warning("Revise NetworkAddress")
public enum InputEvent<NetworkAddress: Hashable> {
   public typealias ConcretePeer = Peer<NetworkAddress>
   case peersDidAppear([PeerEmergence<NetworkAddress>])
   case peersDidDisappear(Set<ConcretePeer.ID>)
//   case peerDidInvite(ConcretePeer.ID)
//   case peerDidAcceptInvitation(ConcretePeer.ID)
   case messageArrived(ConcretePeer.ID, ChatMessage)
   case userAttemptedSendMessage(ConcretePeer.ID, ChatMessage)
   case outgoingMessageWasSentOverNetwork(ChatMessage.ID)
}
