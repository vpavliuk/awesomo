//
//  Transport.swift
//  Messaging App
//
//  Created by Volodymyr Pavliuk on 30.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Utils
import Domain

public struct SendRequest: Identifiable {
   public init(receiver: String, message: NetworkMessage) {
      self.receiver = receiver
      self.message = message
   }
   
   public struct ID: IDType {
      public init(value: UUID = UUID()) {
         self.value = value
      }
      private let value: UUID
   }

   public let id = ID()
   public let receiver: String
   public let message: NetworkMessage
}

public enum NetworkMessage {
   case chatRequest(ChatRequest)
   case chatMessage(ChatMessage)
}
