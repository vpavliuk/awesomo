//
//  TCPMessage.swift
//  Transport Adapter
//
//  Created by Volodymyr Pavliuk on 23.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import TCPTransfer
import Domain
import Utils

public struct TCPUpload: Upload {
   public struct ID: IDType {
      public init(value: UUID = UUID()) {
         self.value = value
      }
      private let value: UUID
   }
   public let id = ID()
   public let receiverServiceName: String
   public let message: TCPMessage
}

public enum TCPMessage: Codable {
   case completeDomainMessage(DomainMessageTCPRepresentation)
   case contentChunk(ContentChunkTCPRepresentation)
}

public struct DomainMessageTCPRepresentation: Codable {
   struct ID: IDType, Codable {
      init(value: UUID = UUID()) {
         self.value = value
      }
      private let value: UUID
   }

   // Only messages with linked content chunks will have a non-nil id.
   // Nil indicates that no content chunks are going to be linked to this message.
   let id: ID?
   let messageType: DomainMessageType
   let payload: Data
}

#warning("Store MessageType in Domain?")
struct DomainMessageType: Codable, Equatable {
   static let chatMessage = Self(value: "CHAT_MESSAGE")
   private let value: String
}

public struct ContentChunkTCPRepresentation: Codable {
   struct ChunkInfo: Codable {
      let chunkIndex: Int
      let totalChunks: Int
      let chatMessageId: DomainMessageTCPRepresentation.ID
   }
   let contentType: ChatMessageContentType
   let payload: Data
}
