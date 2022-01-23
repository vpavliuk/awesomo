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
      case (.sendSuccess(let lhsSendRequestId), .sendSuccess(let rhsSendRequestId)):
         return lhsSendRequestId == rhsSendRequestId
      case (.sendFailure(let lhsSendRequestId), .sendFailure(let rhsSendRequestId)):
         return lhsSendRequestId == rhsSendRequestId
      default:
         return false
      }
   }
}
