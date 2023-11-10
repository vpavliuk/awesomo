//
//  Peer.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

#warning("Revise whether NetworkAddress belongs here from cohesion perspective")
// Maybe a protocol will be enough for Domain
public final class Peer<NetworkAddress: Hashable>: Identifiable {
   convenience init(peerEmergence: PeerEmergence<NetworkAddress>) {
      self.init(
         id: peerEmergence.peerID,
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
      incomingMessages: [ChatMessage] = [],
      pendingOutgoingMessages: [ChatMessage] = [],
      sentMessages: [ChatMessage] = [],
      failedToSendMessages: [ChatMessage] = []
   ) {
      self.id = id
      self.status = status
      self.relation = relation
      self.name = name
      self.networkAddress = networkAddress
      self.incomingMessages = incomingMessages
      self.pendingOutgoingMessages = pendingOutgoingMessages
      self.sentMessages = sentMessages
      self.failedToSendMessages = failedToSendMessages
   }

   public let id: EntityID<Peer, String>

   public enum Status { case online, offline }
   public private(set) var status: Status

   public enum Relation { case stranger, friend, didInviteUs, wasInvited }
   public private(set) var relation: Relation

   public private(set) var name: String
   public let networkAddress: NetworkAddress

   // Messages {
   public private(set) var incomingMessages: [ChatMessage]
   public private(set) var pendingOutgoingMessages: [ChatMessage]
   public private(set) var sentMessages: [ChatMessage]
   public private(set) var failedToSendMessages: [ChatMessage]
   // }

   internal func emerge(_ emergence: PeerEmergence<NetworkAddress>) throws {
      guard status == .offline else {
         throw DomainError.invalidPeerEmergence
      }
      status = .online
      name = emergence.peerName
   }

   internal func invite() throws {
      guard relation == .stranger else {
         throw DomainError.invalidPeerEmergence
      }
      relation = .wasInvited
   }

   internal func disappear() throws {
      guard status != .offline else {
         throw DomainError.invalidPeerDidDisappearEvent
      }
      status = .offline
   }

   internal var isIrrelevant: Bool {
      status == .offline && relation == .stranger
   }
}
