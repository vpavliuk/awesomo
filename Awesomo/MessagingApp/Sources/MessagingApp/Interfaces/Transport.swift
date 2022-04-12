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

public enum InputFromTransport<NetworkAddress> {
   case incomingMessage(NetworkMessage)
   case sendResult(SendResult)

   public typealias SendRequest = TransportSendRequest<NetworkAddress>
   public typealias SendResult = Result<SendRequest.ID, SendError>

   public struct SendError: Error, Equatable {
      let requestID: SendRequest.ID
   }
}

public enum NetworkMessage {
   case chatRequest(ChatRequest)
   case chatMessage(ChatMessage)
}
