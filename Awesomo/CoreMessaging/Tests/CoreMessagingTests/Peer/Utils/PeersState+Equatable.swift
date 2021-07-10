//
//  PeersState+Equatable.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 29.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import CoreMessaging

extension PeersState: Equatable where ConcretePeer: Equatable {
   public static func == (
      lhs: PeersState<ConcretePeer>,
      rhs: PeersState<ConcretePeer>
   ) -> Bool {

      return lhs.availablePeers == rhs.availablePeers
         && lhs.lostPeers == rhs.lostPeers
         && lhs.allPeers == rhs.allPeers
   }
}
