//
//  ChatMessage.swift
//  Domain
//
//  Created by Volodymyr Pavliuk on 11.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

import Foundation

public struct ChatMessage<ContentNetworkRepresentation> {
   public typealias Content = AnyMessageContent<ContentNetworkRepresentation>

   public init(content: Content) {
      self.content = content
   }

   let timestamp = Date()
   let content: Content
}
