//
//  MessageContent.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 23.04.2022.
//  Copyright © 2022 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Combine

public struct MessageContent {
   public init(contentID: ContentID, content: Data) {
      self.contentID = contentID
      self.content = content
   }
   public struct ContentID: Hashable, Codable {
      public init(value: String) {
         self.value = value
      }
      private let value: String
   }
   public let contentID: ContentID
   private let content: Data
   public var dataPublisher: some Publisher<Publishers.Sequence<Data, Never>.Output, Never> { content.publisher }
}

#warning("Equatable problem with MessageContent")
extension MessageContent: Equatable {
   public static func == (lhs: MessageContent, rhs: MessageContent) -> Bool {
      return lhs.contentID == rhs.contentID
   }
}

extension MessageContent: Hashable {
   public func hash(into hasher: inout Hasher) {
      hasher.combine(contentID)
   }
}

extension MessageContent: Codable {
   enum CodingKeys: String, CodingKey {
      case contentID
      case content
   }
}
