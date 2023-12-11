//
//  AwesomelyIdentifiable.swift
//  Domain
//
//  Created by Vova on 11.12.2023.
//

public protocol AwesomelyIdentifiable {
   associatedtype UnderlyingID: Hashable
   var id: EntityID<Self, UnderlyingID> { get }
}

extension AwesomelyIdentifiable {
   public typealias ID = EntityID<Self, UnderlyingID>
}

public struct EntityID<Entity, UnderlyingValue: Hashable>: Hashable {
   public init(value: UnderlyingValue) {
      self.value = value
   }

   private let value: UnderlyingValue
}

extension EntityID: Codable where UnderlyingValue: Codable {}
