//
//  NetworkAddress.swift
//
//
//  Created by Vova on 03.12.2023.
//

#warning("Replace with generic?")
public struct NetworkAddress: Hashable, Codable {
   public init(value: String) {
      self.value = value
   }
   public let value: String
}
