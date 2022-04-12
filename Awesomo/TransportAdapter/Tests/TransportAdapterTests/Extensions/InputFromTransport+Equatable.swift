//
//  InputFromTransport+Equatable.swift
//  
//
//  Created by Volodymyr Pavliuk on 29.08.2021.
//

import MessagingApp

extension InputFromTransport: Equatable {
   public static func == (lhs: InputFromTransport, rhs: InputFromTransport) -> Bool {
      switch (lhs, rhs) {
      case (.incomingMessage(let lhsNetworkMessage), .incomingMessage(let rhsNetworkMessage)):
         return lhsNetworkMessage == rhsNetworkMessage
      case (.sendResult(let lhsSendResult), .sendResult(let rhsSendResult)):
         return lhsSendResult == rhsSendResult

      default:
         return false
      }
   }
}
