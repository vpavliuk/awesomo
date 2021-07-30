//
//  TCPMessage.swift
//  Transport Adapter
//
//  Created by Volodymyr Pavliuk on 23.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Utils
import Domain
import MessagingApp

struct Upload: Identifiable {
   struct ID: IDType {
      init(value: UUID = UUID()) {
         self.value = value
      }
      private let value: UUID
   }
   let id = ID()
   let receiver: String
   let payload: TCPMessagePayload
}

enum TCPMessagePayload: Codable {
   case completeMessage(DomainMessageTCPFormat)
   case contentChunk(ContentChunkTCPFormat)
}

struct DomainMessageTCPFormat: Codable {
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
   private let value: String
}

struct ContentChunkTCPFormat: Codable {
   struct ChunkInfo: Codable {
      let chunkIndex: Int
      let totalChunks: Int
      let chatMessageId: DomainMessageTCPFormat.ID
   }
   let contentType: ChatMessageContentType
   let payload: Data
}
