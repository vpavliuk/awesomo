//
//  Transport.swift
//  Messaging App
//
//  Created by Volodymyr Pavliuk on 30.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Domain

public enum NetworkMessage<ContentNetworkRepresentation> {
   case chatRequest
   case chatMessage//(ChatMessage<ContentNetworkRepresentation>)
}

// MARK: - Output
public struct TransportSendRequest
      <ContentNetworkRepresentation>: Identifiable {
   public typealias ConcreteNetworkMessage = NetworkMessage<ContentNetworkRepresentation>
   public init(receiver: NetworkAddress, message: ConcreteNetworkMessage) {
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
   public let message: ConcreteNetworkMessage
}

// MARK: - Input
public enum InputFromTransport<ContentNetworkRepresentation> {
   case incomingMessage(NetworkMessage<ContentNetworkRepresentation>)
   case sendResult(SendResult)

   public typealias SendRequest = TransportSendRequest<ContentNetworkRepresentation>
   public typealias SendResult = Result<SendRequest.ID, SendError>

   public struct SendError: Error, Equatable {
      public init(requestID: InputFromTransport<ContentNetworkRepresentation>.SendRequest.ID) {
         self.requestID = requestID
      }

      let requestID: SendRequest.ID
   }
}
