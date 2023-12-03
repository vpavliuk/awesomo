//
//  Errors.swift
//  Domain
//
//  Created by Vova on 06.11.2023.
//

// NOTE: A domain error always denotes a bug in the app
public enum DomainError: Error, Equatable {
   case didNotReceiveInitialEvent
   case receivedInitialEventTwice
   case cannotTakeOnlineAlreadyOnlinePeer(Peer.ID)
   case cannotTakeOfflineUnknownPeers(Set<Peer.ID>)
   case cannotTakeOfflineAlreadyOfflinePeer(Peer.ID)
   case cannotInviteUknownPeer(Peer.ID)
   case cannotInviteNonStranger(Peer.ID)
   case cannotHandleInvitationSendingResultForUnknownPeer(Peer.ID)
   case cannotHandleSendingResultForInvitationWhichHadNotBeenPreviouslyInitiated(Peer.ID)
   case unknownPeerCannotRespondToInvitation(Peer.ID)
   case nonInvitedPeerCannotRespondToInvitation(Peer.ID)
}
