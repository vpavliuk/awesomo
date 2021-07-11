//
//  Peer.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 20.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

public protocol Peer: Identifiable where Self.ID: Codable {
   associatedtype Service: BonjourService

   init(
      id: Self.ID,
      displayName: String,
      bonjourService: Self.Service
   )

   var displayName: String { get }
   var bonjourService: Service { get }
   #warning("Add availability state?")
}
