//
//  NetworkAddress.swift
//
//
//  Created by Vova on 03.12.2023.
//

public struct NetworkAddress: Hashable {
   internal init(value: String) {
      self.value = value
   }
   private let value: String
}
