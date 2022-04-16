//
//  ChatMessage.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 11.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation
import Combine

public struct ChatMessage {
   let timestamp = Date()
   #warning("Why just NetworkDispatchable? What about UIPresentable?")
   let content: NetworkDispatchable
}

extension ChatMessage: NetworkDispatchable {
#warning("Do not include contentType!")
   public var tcpChunks: AnyPublisher<Data, Never> {
      Just(
         try! "<message;"
            .data(using: .utf8)! +
            JSONEncoder().encode(timestamp)
      ).eraseToAnyPublisher()
   }
   
   public static let contentType = "message"
}

public struct ChatMessageContentType: Equatable, Codable {
   public init(_ value: String) {
      self.value = value
   }
   private let value: String
}

public protocol ChatMessageContent {
   static var contentType: ChatMessageContentType { get }
}
