//
//  TransportOutput+Equatable.swift
//  
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//

import MessagingApp

extension TransportOutput: Equatable {
   #warning("Dummy implementation")
   public static func == (lhs: TransportOutput, rhs: TransportOutput) -> Bool {
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
