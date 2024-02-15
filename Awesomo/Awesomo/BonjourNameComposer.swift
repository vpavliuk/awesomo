//
//  BonjourNameComposer.swift
//  Awesomo
//
//  Created by Vova on 22.01.2024.
//

import PeerDiscovery
import Domain

struct BonjourNameComposer: BonjourNameComposerProtocol {

   func peerAttributesFromServiceName(_ name: String) -> PeerAttributes {
      let components = name.split(
         separator: separator,
         maxSplits: 1,
         omittingEmptySubsequences: false
      )

      let idString = String(components[0])
      let peerID = Peer.ID(value: idString)

      return PeerAttributes(
         id: peerID,
         peerName: String(components[1])
      )
   }

   public func serviceName(fromIdString id: String, peerName: String) -> String {
      id + String(separator) + peerName
   }

   private let separator: Character = "."
}
