//
//  ChatMessage.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 11.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

public final class ChatMessage: Identifiable {

   init(id: ID, content: MessageContent) {
      self.id = id
      self.timestamp = Date()
      self.content = content
   }

   public let id: EntityID<ChatMessage, UUID>

   public let timestamp: Date
   public let content: MessageContent
}
