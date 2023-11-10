//
//  File.swift
//  Domain
//
//  Created by Vova on 09.11.2023.
//

public struct EntityID<Entity, UnderlyingValue: Hashable>: Hashable {
   public init(value: UnderlyingValue) {
      self.value = value
   }

   private let value: UnderlyingValue
}
