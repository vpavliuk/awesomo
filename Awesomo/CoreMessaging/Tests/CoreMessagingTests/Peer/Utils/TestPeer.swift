//
//  TestPeer.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 20.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

@testable import CoreMessaging

struct TestPeer: Peer, Hashable {
   init(
      id: Self.ID,
      displayName: String,
      bonjourService: TestBonjourService
   ) {
      self.id = id
      self.displayName = displayName
      self.bonjourService = bonjourService
   }

   init(id: Self.ID = "") {
      self.init(
         id: id,
         displayName: "",
         bonjourService: TestBonjourService(name: "\(id).")
      )
   }

   let id: String
   let displayName: String
   let bonjourService: TestBonjourService
}
