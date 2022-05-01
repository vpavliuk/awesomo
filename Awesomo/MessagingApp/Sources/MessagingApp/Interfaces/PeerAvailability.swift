//
//  PeerAvailability.swift
//  Messaging App
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Domain

// MARK: - Input
public struct PeerAvailabilityEvent<NetworkAddress> {
   public typealias Peer = Domain.Peer<NetworkAddress>
   #warning("frozen?")
   public enum AvailabilityChange { case found, lost }

   public init(peers: [Peer], availabilityChange: AvailabilityChange) {
      self.peers = peers
      self.change = availabilityChange
   }

   let peers: [Peer]
   let change: AvailabilityChange
}

extension PeerAvailabilityEvent: Equatable where NetworkAddress: Equatable {
   public static func ==(lhs: Self, rhs: Self) -> Bool {
      lhs.peers == rhs.peers && lhs.change == rhs.change
   }
}
