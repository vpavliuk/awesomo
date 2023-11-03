//
//  Peer.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

#warning("Revise whether NetworkAddress belongs here from cohesion perspective")
public struct Peer<NetworkAddress>: Identifiable {
   public init(id: ID, displayName: String, networkAddress: NetworkAddress) {
      self.id = id
      self.displayName = displayName
      self.networkAddress = networkAddress
   }

   public struct ID: Hashable {
      public init(value: String) {
         self.value = value
      }
      private let value: String
   }

   public let id: ID
   public let displayName: String
   public let networkAddress: NetworkAddress
}
