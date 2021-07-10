//
//  NetworkMessage.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 18.05.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

/// Defines the structure actually transmitted over the network
public struct NetworkMessage<User: Peer, Payload: Codable>: Codable {

   public init(sender: User.ID, payload: Payload) {
      self.sender = sender
      self.payload = payload
   }

   var sender: User.ID
   var payload: Payload
}
