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

public enum NetworkMessage {
   case chatRequest
   case chatMessage(ChatMessage)
}

// MARK: - Output
public struct TransportSendRequest<NetworkAddress>: Identifiable {
   public init(receiver: NetworkAddress, message: NetworkMessage) {
      self.receiver = receiver
      self.message = message
   }
   
   public struct ID: Hashable {
      fileprivate init(value: UUID = UUID()) {
         self.value = value
      }
      private let value: UUID
   }

   public let id = ID()

   public let receiver: NetworkAddress
   public let message: NetworkMessage
}

// MARK: - Input
public enum InputFromTransport<NetworkAddress> {
   case incomingMessage(NetworkMessage)
   case sendResult(SendResult)

   public typealias SendRequest = TransportSendRequest<NetworkAddress>
   public typealias SendResult = Result<SendRequest.ID, SendError>

   public struct SendError: Error, Equatable {
      public init(requestID: InputFromTransport<NetworkAddress>.SendRequest.ID) {
         self.requestID = requestID
      }

      let requestID: SendRequest.ID
   }
}
