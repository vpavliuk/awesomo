//
//  Peer+Equatable.swift
//  Domain
//
//  Created by Vova on 09.11.2023.
//

import Domain

extension Peer: Equatable {
   public static func == (lhs: Domain.Peer<NetworkAddress>, rhs: Domain.Peer<NetworkAddress>) -> Bool {
      return lhs.id == rhs.id
         && lhs.name == rhs.name
         && lhs.status == rhs.status
         && lhs.relation == rhs.relation
         && lhs.networkAddress == rhs.networkAddress
         && lhs.incomingMessages == rhs.incomingMessages
         && lhs.pendingOutgoingMessages == rhs.pendingOutgoingMessages
         && lhs.sentMessages == rhs.sentMessages
         && lhs.failedToSendMessages == rhs.failedToSendMessages
   }
}
