//
//  ChatMessage+Equatable.swift
//  Domain
//
//  Created by Vova on 09.11.2023.
//

import Domain

extension ChatMessage: Equatable {
   public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
      return lhs.id == rhs.id
         && lhs.timestamp == rhs.timestamp
         && lhs.content == rhs.content
   }
}
