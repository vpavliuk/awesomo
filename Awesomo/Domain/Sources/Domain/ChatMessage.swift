//
//  ChatMessage.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 11.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Combine

public struct ChatMessage<ContentNetworkRepresentation> {
   public typealias MessageContent = ChatMessageContent<ContentNetworkRepresentation>
   public init(content: MessageContent) {
      self.content = content
   }

   let timestamp = Date()
   let content: MessageContent
}

public struct ChatMessageContent<NetworkRepresentation> {
   public struct ContentType: Equatable {
      public init(_ value: String) {
         self.value = value
      }
      private let value: String
   }

   public let contentType: ContentType

   #warning("Don't forget about errors")
   public let networkPublisher: AnyPublisher<NetworkRepresentation, Never>
}
