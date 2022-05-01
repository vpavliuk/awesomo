//
//  Peer.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

public struct Peer<NetworkAddress>: Identifiable {

   public init(displayName: String, networkAddress: NetworkAddress) {
      self.displayName = displayName
      self.networkAddress = networkAddress
   }

   public struct ID: Hashable {
      public init(value: UUID = UUID()) {
         self.value = value
      }
      private let value: UUID
   }

   public let id = ID()
   public let displayName: String
   public let networkAddress: NetworkAddress
}

extension Peer: Equatable where NetworkAddress: Equatable {
   public static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.id == rhs.id
         && lhs.displayName == rhs.displayName
         && lhs.networkAddress == rhs.networkAddress
   }
}
