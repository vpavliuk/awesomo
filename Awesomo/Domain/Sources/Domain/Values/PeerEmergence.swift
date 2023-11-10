//
//  PeerEmergence.swift
//  Domain
//
//  Created by Vova on 06.11.2023.
//

public struct PeerEmergence<NetworkAddress: Hashable>: Hashable {
   public init(peerID: PeerEmergence<NetworkAddress>.PeerID, peerName: String, peerAddress: NetworkAddress) {
      self.peerID = peerID
      self.peerName = peerName
      self.peerAddress = peerAddress
   }

   public typealias PeerID = Peer<NetworkAddress>.ID
   let peerID: PeerID
   let peerName: String
   let peerAddress: NetworkAddress
}
