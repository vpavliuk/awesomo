//
//  NetworkMessage+Equatable.swift
//  
//
//  Created by Volodymyr Pavliuk on 03.11.2021.
//

import MessagingApp

extension NetworkMessage: Equatable {
   public static func == (lhs: NetworkMessage, rhs: NetworkMessage) -> Bool {
      switch (lhs, rhs) {
      case (.chatRequest, .chatRequest):
         return true
      case (.chatMessage(let lhsChatMessage), .chatMessage(let rhsChatMessage)):
         return lhsChatMessage == rhsChatMessage
      default:
         return false
      }
   }
}
