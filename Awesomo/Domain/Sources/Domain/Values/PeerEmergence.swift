//
//  PeerEmergence.swift
//  Domain
//
//  Created by Vova on 06.11.2023.
//

public struct PeerEmergence: Hashable, Codable {
   public init(peerName: String, peerAddress: NetworkAddress) {
      self.peerName = peerName
      self.peerAddress = peerAddress
   }

   let peerName: String
   let peerAddress: NetworkAddress
}
