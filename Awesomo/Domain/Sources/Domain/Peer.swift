//
//  Peer.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 22.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

public protocol Peer: Identifiable where Self.ID: Codable {

   init(
      id: Self.ID,
      displayName: String,
      networkServiceName: String
   )

   var displayName: String { get }
   var networkServiceName: String { get }
   #warning("Add availability state?")
}
