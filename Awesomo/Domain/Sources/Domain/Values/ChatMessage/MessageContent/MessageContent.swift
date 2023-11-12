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
   public struct ContentID: Hashable {
      private let value: String
   }
   public let contentID: ContentID
   public let dataPublisher: some Publisher<Data, Never> = "Hello"
      .data(using: .utf8)
      .publisher
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
