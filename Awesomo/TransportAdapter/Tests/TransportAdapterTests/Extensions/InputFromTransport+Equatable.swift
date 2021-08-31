//
//  InputFromTransport+Equatable.swift
//  
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//

import MessagingApp

extension InputFromTransport: Equatable {
   #warning("Dummy implementation")
   public static func == (lhs: InputFromTransport, rhs: InputFromTransport) -> Bool {
      switch (lhs, rhs) {
      case (.incomingMessage(_), .incomingMessage(_)):
         return true
      case (.sendSuccess(_), .sendSuccess(_)):
         return true
      case (.sendFailure(_), .sendFailure(_)):
         return true
      default:
         return false
      }
   }
}
