//
//  Peer.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

#warning("Revise whether NetworkAddress belongs here from cohesion perspective")
public final class Peer<NetworkAddress: Hashable>: Entity {
   internal convenience init(id: ID, peerEmergence: PeerEmergence<NetworkAddress>) {
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

   public enum Relation: Hashable { case stranger, friend, didInviteUs, wasInvited }
   private var relation: Relation

   private var name: String
   private let networkAddress: NetworkAddress

   // Messages from this peer to us
   private var incomingMessages: [IncomingChatMessage]

   // Messages from us to this peer
   private var outgoingMessages: [OutgoingChatMessage]

   internal func takeOnline(_ emergence: PeerEmergence<NetworkAddress>) throws {
      guard status == .offline else {
         throw DomainError.cannotTakeOnlineAlreadyOnlinePeer(id)
      }
      status = .online
      name = emergence.peerName
   }

   internal func takeOffline() throws {
      guard status != .offline else {
         throw DomainError.cannotTakeOfflineAlreadyOfflinePeer(id)
      }
      status = .offline
   }

   internal func invite() throws {
      guard relation == .stranger else {
         throw DomainError.cannotInviteNonStranger(id)
      }
      relation = .wasInvited
   }

   internal var isIrrelevant: Bool {
      status == .offline && relation == .stranger
   }
}

extension Peer {
   public struct Snapshot: Hashable {
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
