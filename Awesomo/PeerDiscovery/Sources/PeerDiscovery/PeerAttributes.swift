//
//  PeerAttributes.swift
//
//
//  Created by Vova on 23.01.2024.
//

import Domain

public struct PeerAttributes {
   public init(id: Peer.ID, peerName: String) {
      self.id = id
      self.peerName = peerName
   }

   let id: Peer.ID
   let peerName: String
}
