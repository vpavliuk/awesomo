//
//  Entity.swift
//  Domain
//
//  Created by Vova on 12.11.2023.
//

protocol Entity: Identifiable {
   associatedtype UnderlyingID: Hashable
   var id: EntityID<Self, UnderlyingID> { get }

   associatedtype Snapshot: Hashable
   func snapshot() -> Snapshot
}

public struct EntityID<Entity, UnderlyingValue: Hashable>: Hashable {
   public init(value: UnderlyingValue) {
      self.value = value
   }

   private let value: UnderlyingValue
}

extension Collection where Element: Entity {
   func snapshot() -> [Element.Snapshot] {
      map { $0.snapshot() }
   }
}
