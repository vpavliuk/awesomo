//
//  BonjourNameComposerMock.swift
//  Peer Discovery
//
//  Created by Volodymyr Pavliuk on 25.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

@testable
import PeerDiscovery
import Domain

struct BonjourNameComposerMock: BonjourNameComposerProtocol {

   func peerAttributesFromServiceName(_ name: String) -> PeerAttributes {
      let components = name.split(
         separator: separator,
         maxSplits: 1,
         omittingEmptySubsequences: false
      )

      let idString = String(components[0])
      let peerId = Peer.ID(value: idString)
      return PeerAttributes(
         id: peerId,
         peerName: String(components[1])
      )
   }

   func serviceName(fromIdString id: String, peerName: String) -> String {
      id + String(separator) + peerName
   }

   private let separator: Character = "."
}
