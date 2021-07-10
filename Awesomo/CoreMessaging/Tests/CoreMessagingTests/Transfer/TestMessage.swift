//
//  TestMessage.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 06.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import CoreMessaging

struct TestMessage: Message {
   init(id: String, payload: Int) {
      self.id = id
      self.payload = payload
   }

   init(payload: Int) {
      self.init(id: "", payload: payload)
   }

   init (id: Self.ID = "") {
      self.init(id: id, payload: 0)
   }

   let id: String
   let payload: Int
}
