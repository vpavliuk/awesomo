//
//  IncomingChatMessage.swift
//  Domain
//
//  Created by Vova on 12.11.2023.
//

import Foundation

public struct IncomingChatMessage: Hashable {
   public init(timestamp: Date, content: MessageContent) {
      self.timestamp = timestamp
      self.content = content
   }

   public let timestamp: Date
   public let content: MessageContent
}

extension IncomingChatMessage: Codable {}
