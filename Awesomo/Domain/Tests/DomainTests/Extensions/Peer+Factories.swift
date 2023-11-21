//
//  Peer+Factories.swift
//  Domain
//
//  Created by Vova on 21.11.2023.
//

@testable import Domain

extension Peer.Snapshot {
   static func makeOnlineStranger(
      id: Peer.ID,
      name: String,
      address: NetworkAddress
   ) -> Self {
      return .init(
         peerID: id,
         status: .online,
         relation: .stranger,
         name: name,
         networkAddress: address,
         incomingMessages: [],
         outgoingMessages: []
      )
   }

   static func makeOfflineStranger(
      id: Peer.ID,
      name: String,
      address: NetworkAddress
   ) -> Self {
      return .init(
         peerID: id,
         status: .offline,
         relation: .stranger,
         name: name,
         networkAddress: address,
         incomingMessages: [],
         outgoingMessages: []
      )
   }

   static func makeOnlineFriend(
      id: Peer.ID,
      name: String,
      address: NetworkAddress
   ) -> Self {
      return .init(
         peerID: id,
         status: .online,
         relation: .friend,
         name: name,
         networkAddress: address,
         incomingMessages: [],
         outgoingMessages: []
      )
   }

   static func makeOfflineFriend(
      id: Peer.ID,
      name: String,
      address: NetworkAddress
   ) -> Self {
      return .init(
         peerID: id,
         status: .offline,
         relation: .friend,
         name: name,
         networkAddress: address,
         incomingMessages: [],
         outgoingMessages: []
      )
   }
}
