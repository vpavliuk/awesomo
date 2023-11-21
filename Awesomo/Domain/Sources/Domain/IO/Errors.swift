//
//  Errors.swift
//  Domain
//
//  Created by Vova on 06.11.2023.
//

public enum DomainError<NetworkAddress: Hashable>: Error, Equatable {
   public typealias PeerID = Peer<NetworkAddress>.ID
   case didNotReceiveInitialEvent
   case receivedInitialEventTwice
   case cannotTakeOnlineAlreadyOnlinePeer(PeerID)
   case cannotTakeOfflineUnknownPeers(Set<PeerID>)
   case cannotTakeOfflineAlreadyOfflinePeer(PeerID)
   case cannotInviteUknownPeer(PeerID)
   case cannotInviteNonStranger(PeerID)
   case unknownPeerCannotAcceptInvitation(PeerID)
   case nonInvitedPeerCannotAcceptInvitation(PeerID)
}
