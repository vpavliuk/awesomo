//
//  Peer.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

public final class Peer: AwesomelyIdentifiable {
   internal convenience init(id: ID, peerEmergence: PeerEmergence) {
      self.init(
         id: id,
         status: .online,
         relation: .stranger,
         name: peerEmergence.peerName,
         networkAddress: peerEmergence.peerAddress
      )
   }

   internal init(
      id: ID,
      status: Status,
      relation: Relation,
      name: String,
      networkAddress: NetworkAddress,
      incomingMessages: [IncomingChatMessage] = [],
      outgoingMessages: [OutgoingChatMessage] = []
   ) {
      self.id = id
      self.status = status
      self.relation = relation
      self.name = name
      self.networkAddress = networkAddress
      self.incomingMessages = incomingMessages
      self.outgoingMessages = outgoingMessages
   }

   public let id: EntityID<Peer, String>

   public enum Status: Hashable { case online, offline }
   private var status: Status

   // Relation to the local user
   public enum Relation: Hashable { case stranger, friend, didInviteUs, invitationAcceptanceInitiatedByUs, invitationInitiatedByUs, wasInvitedByUs }
   private var relation: Relation

   private var name: String

   #warning("Revise whether NetworkAddress belongs here from cohesion perspective")
   private var networkAddress: NetworkAddress

   // Messages from this peer to us
   private var incomingMessages: [IncomingChatMessage]

   // Messages from us to this peer
   private var outgoingMessages: [OutgoingChatMessage]

   internal func takeOnline(_ emergence: PeerEmergence) throws {
      guard status == .offline else {
         throw DomainError.cannotTakeOnlineAlreadyOnlinePeer(id)
      }
      status = .online
      name = emergence.peerName
      networkAddress = emergence.peerAddress
   }

   internal func takeOffline() throws {
      guard status != .offline else {
         throw DomainError.cannotTakeOfflineAlreadyOfflinePeer(id)
      }

      status = .offline

      if relation != .friend {
         relation = .stranger
      }
   }

   internal func initiateInvitation() throws {
      guard relation == .stranger else {
         throw DomainError.cannotInviteNonStranger(id)
      }
      relation = .invitationInitiatedByUs
   }

   internal func onInvitationSuccesfullySent() throws {
      guard relation == .invitationInitiatedByUs else {
         throw DomainError.cannotHandleSendingResultForInvitationWhichHadNotBeenPreviouslyInitiated(id)
      }
      relation = .wasInvitedByUs
   }

   internal func onFailedToSendInvitation() throws {
      guard relation == .invitationInitiatedByUs else {
         throw DomainError.cannotHandleSendingResultForInvitationWhichHadNotBeenPreviouslyInitiated(id)
      }
      relation = .stranger
   }

   internal func acceptInvitation() throws {
      guard relation == .wasInvitedByUs else {
         throw DomainError.nonInvitedPeerCannotRespondToInvitation(id)
      }
      relation = .friend
   }

   internal var isIrrelevant: Bool {
      status == .offline && relation == .stranger
   }

   internal func inviteUs() throws {
      guard relation == .stranger else {
         throw DomainError.cannotReceiveInvitationFromNonStrangerPeer(id)
      }

      relation = .didInviteUs
   }

   internal func onInvitationAcceptedByUs() throws {
      guard relation == .didInviteUs else {
         throw DomainError.cannotRespondToInvitationFromPeerWhoHadNotPreviouslyInviteUs(id)
      }
      guard status == .online else {
         throw DomainError.cannotRespondToInvitationIfPeerIsOffline(id)
      }

      relation = .invitationAcceptanceInitiatedByUs
   }

   internal func onInvitationAcceptanceSuccessfullySent() throws {
      guard relation == .invitationAcceptanceInitiatedByUs else {
         throw DomainError.cannotHandleSendingResultForAcceptanceWhichHadNotBeenPreviouslyInitiated(id)
      }
      relation = .friend
   }

   internal func onFailedToSendInvitationAcceptance() throws {
      guard relation == .invitationAcceptanceInitiatedByUs else {
         throw DomainError.cannotHandleSendingResultForAcceptanceWhichHadNotBeenPreviouslyInitiated(id)
      }
      relation = .stranger
   }
}

extension Peer: SnapshotProducer {
   #warning("Try to get rid of snaphots. Let's just treat entities as state")
   public struct Snapshot: Hashable {
      public init(
         peerID: Peer.ID,
         status: Peer.Status,
         relation: Peer.Relation,
         name: String,
         networkAddress: NetworkAddress,
         incomingMessages: [IncomingChatMessage],
         outgoingMessages: [OutgoingChatMessage.Snapshot]
      ) {
         self.peerID = peerID
         self.status = status
         self.relation = relation
         self.name = name
         self.networkAddress = networkAddress
         self.incomingMessages = incomingMessages
         self.outgoingMessages = outgoingMessages
      }

      public let peerID: ID
      public let status: Status
      public let relation: Relation
      public let name: String
      public let networkAddress: NetworkAddress
      public let incomingMessages: [IncomingChatMessage]
      public let outgoingMessages: [OutgoingChatMessage.Snapshot]
   }

   func snapshot() -> Snapshot {
      Snapshot(
         peerID: id,
         status: status,
         relation: relation,
         name: name,
         networkAddress: networkAddress,
         incomingMessages: incomingMessages,
         outgoingMessages: outgoingMessages.map { $0.snapshot() }
      )
   }
}
