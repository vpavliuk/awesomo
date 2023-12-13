//
//  BonjourNameComposer.swift
//  Peer Discovery
//
//  Created by Volodymyr Pavliuk on 25.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Domain

public protocol BonjourNameComposer {
   func peerAttributesFromServiceName(_ name: String)
         -> (id: Peer.ID, peerName: String)
}

public struct BonjourNameComposerImpl: BonjourNameComposer {
   public init() {}
   public func peerAttributesFromServiceName(_ name: String)
         -> (id: Peer.ID, peerName: String) {

      let components = name.split(
         separator: separator,
         maxSplits: 1,
         omittingEmptySubsequences: false
      )

      let idString = String(components[0])
      let peerId = Peer.ID(value: idString)
      return (
         id: peerId,
         peerName: String(components[1])
      )
   }

   public func serviceName(fromIdString id: String, peerName: String) -> String {
      id + String(separator) + peerName
   }

   private let separator: Character = "."
}
