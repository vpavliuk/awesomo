//
//  PeersState.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 22.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public final class PeersState<ConcretePeer: Peer>: ObservableObject {

   internal init(availablePeers: [ConcretePeer] = [], lostPeers: [ConcretePeer] = []) {
      self.availablePeers = availablePeers
      self.lostPeers = lostPeers
   }

   @Published public var availablePeers: [ConcretePeer]
   @Published public var lostPeers: [ConcretePeer]

   public var allPeers: [ConcretePeer] { availablePeers + lostPeers }
}
