//
//  BonjourNameComposer.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 15.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

public struct BonjourNameComposer<ConcretePeer: Peer> where ConcretePeer.ID == String {

   public init() {}

   static var separator: Character { "." }

   func components(fromName name: String) throws
         -> (id: ConcretePeer.ID, displayName: String) {

      guard name.contains(Self.separator) else {
         throw CoreMessagingError.invalidArgument(arg: name)
      }
      let components = name.split(
         separator: Self.separator,
         maxSplits: 1,
         omittingEmptySubsequences: false
      )
      assert(components.count == 2)

      return (
         id: String(components[0]),
         displayName: String(components[1])
      )
   }

   public func name(fromId id: ConcretePeer.ID, displayName: String) -> String {
      return id + String(Self.separator) + displayName
   }
}
