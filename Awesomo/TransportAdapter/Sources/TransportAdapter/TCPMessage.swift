//
//  TCPMessage.swift
//  Transport Adapter
//
//  Created by Volodymyr Pavliuk on 23.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import TCPTransfer

public struct TCPUpload: Upload {
   init(id: ID, receiverServiceName: String, message: Data) {
      self.id = id
      self.receiverServiceName = receiverServiceName
      self.message = message
   }

   public struct ID: Hashable {
      init(value: UUID = UUID()) {
         self.value = value
      }
      private let value: UUID
   }

   public let id: ID
   public let receiverServiceName: String
   public let message: Data
}

#warning("Revise")
//public enum TCPMessage: Codable {
//   case completeDomainMessage(DomainMessageTCPRepresentation)
//   case contentChunk(ContentChunkTCPRepresentation)
//}

//public struct DomainMessageTCPRepresentation: Codable {
//   public init(id: ID?, messageType: DomainMessageType, payload: Data) {
//      self.id = id
//      self.messageType = messageType
//      self.payload = payload
//   }
//
//   public struct ID: IDType, Codable {
//      public init(value: UUID = UUID()) {
//         self.value = value
//      }
//      private let value: UUID
//   }
//
//   #warning("Should be revised")
//   // Only messages with linked content chunks will have a non-nil id.
//   // Nil indicates that no content chunks are going to be linked to this message.
//   public let id: ID?
//   public let messageType: DomainMessageType
//   public let payload: Data
//}

#warning("Store MessageType in Domain?")
//public struct DomainMessageType: Codable, Equatable {
//   public static let chatRequest = Self(value: "CHAT_REQUEST")
//   public static let chatMessage = Self(value: "CHAT_MESSAGE")
//   private let value: String
//}

//public struct ContentChunkTCPRepresentation: Codable {
//   public struct ChunkInfo: Codable {
//      let chunkIndex: Int
//      let totalChunks: Int
//      let chatMessageId: DomainMessageTCPRepresentation.ID
//   }
//   public let contentType: ChatMessageContentType
//   public let payload: Data
//}
