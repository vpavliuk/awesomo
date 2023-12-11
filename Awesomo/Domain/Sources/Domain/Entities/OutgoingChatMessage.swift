//
//  OutgoingChatMessage.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 11.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

public final class OutgoingChatMessage: AwesomelyIdentifiable {

   init(id: ID, content: MessageContent, status: Status) {
      self.id = id
      self.timestamp = Date()
      self.content = content
      self.status = status
   }

   public let id: EntityID<OutgoingChatMessage, UUID>
   let timestamp: Date
   let content: MessageContent

   public enum Status { case pending, sent, failed }
   var status: Status
}

extension OutgoingChatMessage: SnapshotProducer {
   public struct Snapshot: Hashable {
      public let timestamp: Date
      public let content: MessageContent
      public let status: Status
   }

   func snapshot() -> Snapshot {
      Snapshot(timestamp: timestamp, content: content, status: status)
   }
}
