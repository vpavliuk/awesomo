//
//  PeerAvailabilityEvent.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

// MARK: - Input
#warning("Revise NetworkAddress")
enum PeerAvailabilityEvent<NetworkAddress> {
   public typealias ConcretePeer = Domain.Peer<NetworkAddress>
   case peersDidAppear([Peer<ConcretePeer>])
   case peersDidDisappear(Set<ConcretePeer.ID>)
}
