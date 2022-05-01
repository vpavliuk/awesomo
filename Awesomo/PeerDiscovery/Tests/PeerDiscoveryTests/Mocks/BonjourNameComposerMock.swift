//
//  BonjourNameComposerMock.swift
//  Peer Discovery
//
//  Created by Volodymyr Pavliuk on 25.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import PeerDiscovery
import Domain

struct BonjourNameComposerMock: BonjourNameComposer {

   static let separator: Character = "."

   func peerAttributesFromServiceName(_ name: String)
         -> (id: Peer<String>.ID, displayName: String) {

      let components = name.split(
         separator: Self.separator,
         maxSplits: 1,
         omittingEmptySubsequences: false
      )

      let idString = String(components[0])
      let peerId = Peer<String>.ID(value: UUID(uuidString: idString)!)
      return (
         id: peerId,
         displayName: String(components[1])
      )
   }

   func serviceName(fromIdString id: String, displayName: String) -> String {
      id + String(Self.separator) + displayName
   }
}
